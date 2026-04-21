module i2c_driver(
    input sys_clk,
    input sys_rst_n,
    
    input start,
    input c_d,
    input [7:0] command,
    input [7:0] param_1,
    input [7:0] param_2,
    input [1:0] with_param,
    input [7:0] pixel_data,
    input [7:0] pixel_length,
    output reg done,
    output reg busy,
    output scl,
    inout sda
);

parameter I2C_ADDR = 8'h78;
parameter CONTROL  = 8'h00;
parameter DATA     = 8'h40;

parameter IDLE                     = 9'b0_0000_0001;
parameter START                    = 9'b0_0000_0010;
parameter ADDR                     = 9'b0_0000_0100;//78
parameter CONTROL_OR_DATA_BYTE     = 9'b0_0000_1000;//00 or 40
parameter COMMAND_BYTE             = 9'b0_0001_0000;
parameter PARAMETER_1_BYTE         = 9'b0_0010_0000;
parameter PARAMETER_2_BYTE         = 9'b0_0100_0000;
parameter PIXEL_BYTE               = 9'b0_1000_0000;
parameter STOP                     = 9'b1_0000_0000;

parameter START_HOLD_CNT = 5'b0_0100;
parameter STOP_HOLD_CNT  = 5'b1_0000;

reg [8:0] cur_state;
reg [8:0] next_state;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        cur_state <= IDLE;
    end
    else begin
        cur_state <= next_state;
    end
end

wire send_done;
reg [4:0] pulse_cnt;
reg [7:0] pixel_cnt;

always @(*) begin
    case (cur_state)
        IDLE:           next_state = (start) ? START : IDLE;
        START:          next_state = (pulse_cnt == START_HOLD_CNT) ? ADDR : START;
        ADDR:           next_state = (send_done) ? CONTROL_OR_DATA_BYTE : ADDR;
        CONTROL_OR_DATA_BYTE:   begin
            if (send_done) next_state = (c_d) ? PIXEL_BYTE : COMMAND_BYTE;
            else next_state = CONTROL_OR_DATA_BYTE;
        end
        COMMAND_BYTE:   begin
            if (send_done) next_state = (with_param == 2'b00) ? STOP : PARAMETER_1_BYTE;
            else next_state = COMMAND_BYTE;
        end
        PARAMETER_1_BYTE: begin
            if (send_done) next_state = (with_param == 2'b01) ? STOP : PARAMETER_2_BYTE;
            else next_state = PARAMETER_1_BYTE;
        end
        PARAMETER_2_BYTE: next_state = (send_done) ? STOP : PARAMETER_2_BYTE;
        PIXEL_BYTE:     next_state = (pixel_cnt == pixel_length) ? STOP : PIXEL_BYTE;
        STOP:           next_state = (done) ? IDLE : STOP;
        default:        next_state = IDLE;
    endcase
end

wire i2c_clk;

reg send_start;
wire need_release;
wire error;
wire send_busy;

reg [7:0] data;

reg scl_buf;
wire sub_scl;
assign scl = (send_start) ? sub_scl : scl_buf;

wire sub_sda;
wire sda_out;
wire sda_in;
reg sda_buf;
wire i2c_send_one_byte_sda;
reg [4:0] error_cnt;

assign sda = (need_release) ? 1'b0 : sda_out;
assign sda_in = sda;
assign sda_out = (send_start) ? sub_sda : sda_buf;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        send_start <= 1'b0;
        sda_buf    <= 1'b1;
        error_cnt  <= 5'd0;
        done       <= 1'b0;
        busy       <= 1'b0;
        pulse_cnt  <= 5'b0_0001;
        scl_buf    <= 1'b1;
        pixel_cnt  <= 8'd0;
    end
    else begin
        done <= 1'b0;
        case (cur_state)
            IDLE: begin
                sda_buf    <= 1'b1;
                scl_buf    <= 1'b1;
                send_start <= 1'b0;
                error_cnt  <= 5'd0;
                busy       <= 1'b0;
                pulse_cnt  <= 5'b0_0001;
                done <= 1'b0;
                pixel_cnt  <= 8'd0; 
            end
            START: begin
                sda_buf <= 1'b0;
                busy <= 1'b1;
                send_start <= 1'b0;
                if (i2c_clk) begin
                    pulse_cnt <= pulse_cnt << 1'b1;
                end
            end
            ADDR: begin
                pulse_cnt <= 5'b0_0001;
                data <= I2C_ADDR;
                send_start <= 1'b1;
                error_cnt[0] <= error;
            end
            CONTROL_OR_DATA_BYTE: begin
                data <= (c_d) ? DATA : CONTROL;
                send_start <= 1'b1;
                error_cnt[1] <= error;
            end
            COMMAND_BYTE: begin
                data <= command;
                send_start <= 1'b1;
                error_cnt[2] <= error;
            end
            PARAMETER_1_BYTE: begin
                data <= param_1;
                send_start <= 1'b1;
                error_cnt[3] <= error;
            end
            PARAMETER_2_BYTE: begin
                data <= param_2;
                send_start <= 1'b1;
                error_cnt[4] <= error;
            end
            PIXEL_BYTE: begin
                data <= pixel_data;
                send_start <= 1'b1;
                error_cnt[2] <= error;
                pixel_cnt <= (send_done) ? pixel_cnt + 1'b1 : pixel_cnt;
            end
            STOP: begin
                busy <= 1'b0;
                send_start <= 1'b0;
                if (i2c_clk) begin
                    case (pulse_cnt)
                        5'b0_0001:scl_buf <= 1'b0;
                        5'b0_0010:sda_buf <= 1'b0;
                        5'b0_0100:scl_buf <= 1'b1;
                        5'b0_1000:sda_buf <= 1'b1;
                        5'b1_0000:done <= 1'b1;
                    endcase
                    pulse_cnt <= (pulse_cnt == STOP_HOLD_CNT) ? 5'b0_0001 : pulse_cnt << 1'b1;
                end
            end
            default: begin
                sda_buf <= 1'b1;
                send_start <= 1'b0;
                pulse_cnt  <= 5'b0_0001;
                pixel_cnt  <= 8'd0;
            end
        endcase
    end
end


i2c_send_one_byte u_i2c_send_one_byte(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),

    .i2c_clk(i2c_clk),
    .data(data),
    .start(send_start),
    .sub_scl(sub_scl),
    .sda_out(sub_sda),
    .sda_in(sda_in),
    .done(send_done),
    .busy(send_busy),
    .error(error),
    .need_release(need_release)
);

i2c_clock u_i2c_clock(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),

    .i2c_clk(i2c_clk)
);

endmodule
