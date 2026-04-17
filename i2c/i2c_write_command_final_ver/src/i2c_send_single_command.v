module i2c_send_single_command(
    input sys_clk,
    input sys_rst_n,
    
    input start,
    input [7:0] command,
    input [7:0] param,
    input with_param,
    output reg done,
    output reg busy,
    output scl,
    inout sda
);

parameter I2C_ADDR = 8'h78;
parameter CONTROL  = 8'h00;

parameter IDLE           = 7'b000_0001;
parameter START          = 7'b000_0010;
parameter ADDR           = 7'b000_0100;
parameter CONTROL_BYTE   = 7'b000_1000;
parameter COMMAND_BYTE   = 7'b001_0000;
parameter PARAMETER_BYTE = 7'b010_0000;
parameter STOP           = 7'b100_0000;

parameter START_HOLD_CNT = 4'b0100;
parameter STOP_HOLD_CNT  = 4'b1000;

reg [6:0] cur_state;
reg [6:0] next_state;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        cur_state <= IDLE;
    end
    else begin
        cur_state <= next_state;
    end
end

wire send_done;
reg [3:0] pulse_cnt;

always @(*) begin
    case (cur_state)
        IDLE:           next_state = (start) ? START : IDLE;
        START:          next_state = (pulse_cnt == START_HOLD_CNT) ? ADDR : START;
        ADDR:           next_state = (send_done) ? CONTROL_BYTE : ADDR;
        CONTROL_BYTE:   next_state = (send_done) ? COMMAND_BYTE : CONTROL_BYTE;
        COMMAND_BYTE:   begin
            if (send_done) next_state = (with_param) ? PARAMETER_BYTE : STOP;
            else next_state = COMMAND_BYTE;
        end
        PARAMETER_BYTE: next_state = (send_done) ? STOP : PARAMETER_BYTE;
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
reg [3:0] error_cnt;

assign sda = (need_release) ? 1'bz : sda_out;
assign sda_in = sda;
assign sda_out = (send_start) ? sub_sda : sda_buf;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        send_start <= 1'b0;
        sda_buf    <= 1'b1;
        error_cnt  <= 4'd0;
        done       <= 1'b0;
        busy       <= 1'b0;
        pulse_cnt  <= 4'b0001;
        scl_buf    <= 1'b1;
    end
    else begin
        case (cur_state)
            IDLE: begin
                sda_buf    <= 1'b1;
                scl_buf    <= 1'b1;
                send_start <= 1'b0;
                error_cnt  <= 4'd0;
                busy       <= 1'b0;
                pulse_cnt  <= 4'b0001;
                done <= 1'b0;
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
                pulse_cnt <= 4'b0001;
                data <= I2C_ADDR;
                send_start <= 1'b1;
                error_cnt[0] <= error;
            end
            CONTROL_BYTE: begin
                data <= CONTROL;
                send_start <= 1'b1;
                error_cnt[1] <= error;
            end
            COMMAND_BYTE: begin
                data <= command;
                send_start <= 1'b1;
                error_cnt[2] <= error;
            end
            PARAMETER_BYTE: begin
                data <= param;
                send_start <= 1'b1;
                error_cnt[3] <= error;
                scl_buf <= 1'b0;
            end
            STOP: begin
                busy <= 1'b0;
                send_start <= 1'b0;
                if (i2c_clk) begin
                    case (pulse_cnt)
                        4'b0001:sda_buf <= 1'b0;
                        4'b0010:scl_buf <= 1'b1;
                        4'b0100:sda_buf <= 1'b1;
                        4'b1000:done <= 1'b1;
                    endcase
                    pulse_cnt <= (pulse_cnt == STOP_HOLD_CNT) ? 4'b0001 : pulse_cnt << 1'b1;
                end
            end
            default: begin
                sda_buf <= 1'b1;
                send_start <= 1'b0;
                pulse_cnt  <= 4'b0001;
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
