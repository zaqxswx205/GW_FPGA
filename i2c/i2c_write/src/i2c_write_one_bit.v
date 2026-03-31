module i2c_write_one_bit(
    input sys_clk,
    input sys_rst_n,

    output scl,
    inout sda
);

parameter I2C_ADDR = 8'h78;
parameter CONTROL  = 8'h00;
parameter COMMAND  = 8'hae;

parameter IDLE         = 6'b00_0001;
parameter START        = 6'b00_0010;
parameter ADDR         = 6'b00_0100;
parameter CONTROL_BYTE = 6'b00_1000;
parameter COMMAND_BYTE = 6'b01_0000;
parameter STOP         = 6'b10_0000;

wire i2c_clk;

reg scl_buf;
reg sda_out;
reg sda_en;
wire sda_in;

assign scl = scl_buf;
assign sda = sda_en ? sda_out : 1'bz;
assign sda_in = sda;

reg [5:0] cur_state;
reg [5:0] next_state;

wire done_buf;
reg done_d;
wire done;

always @(posedge i2c_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        done_d <= 1'b0;
    end
    else begin
        done_d <= done_buf;
    end
end
assign done = done_buf & ~done_d;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        cur_state <= IDLE;
    end
    else begin
        if (cur_state == IDLE) begin
            cur_state <= next_state;
        end
        else if (cur_state == START) begin
            cur_state <= (!sda) ? next_state : cur_state;
        end
        else if (cur_state == STOP) begin
            cur_state <= (sda) ? next_state : cur_state;
        end
        else begin
            cur_state <= (done) ? next_state : cur_state;
        end
    end
end

always @(*) begin
    next_state = cur_state;
    case (cur_state)
        IDLE:begin
            next_state = START;
        end
        START:begin
            next_state = ADDR;
        end
        ADDR:begin
            next_state = CONTROL_BYTE;
        end
        CONTROL_BYTE:begin
            next_state = COMMAND_BYTE;
        end
        COMMAND_BYTE:begin
            next_state = STOP;
        end
        STOP:begin
            next_state = IDLE;
        end
        default:begin
            next_state = IDLE;
        end
    endcase
end


reg [3:0] bit_cnt;
reg [7:0] data;
reg start;
wire send_scl;
wire need_release;
wire send_sda;

always @(posedge i2c_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        scl_buf <= 1'b1;
        sda_out <= 1'b1;
        sda_en <= 1'b1;
        bit_cnt <= 4'd0;
    end
    else begin
        case (cur_state)
            IDLE:begin
                scl_buf <= 1'b1;
                sda_out <= 1'b1;
                sda_en <= 1'b1;
                bit_cnt <= 4'd0;
            end
            START:begin
                sda_en <= 1'b1;
                sda_out <= 1'b0;
            end
            ADDR:begin
                data <= I2C_ADDR;
                start <= 1'b1;
                scl_buf <= send_scl;
                sda_out <= send_sda;
                sda_en <= need_release;
            end
            CONTROL_BYTE:begin
                data <= CONTROL;
                start <= 1'b1;
                scl_buf <= send_scl;
                sda_out <= send_sda;
                sda_en <= need_release;
            end
            COMMAND_BYTE:begin
                data <= COMMAND;
                start <= 1'b1;
                scl_buf <= send_scl;
                sda_out <= send_sda;
                sda_en <= need_release;
            end
            STOP:begin
                start <= 1'b0;
                scl_buf <= 1'b1;
                sda_out <= 1'b1;
                sda_en <= 1'b1;
            end
            default:begin
            end
        endcase
    end
end

i2c_send u_i2c_send(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),

    .i2c_clk(i2c_clk),
    .data(data),
    .start(start),
    .scl(send_scl),
    .sda_out(send_sda),
    .done(done_buf),
    .need_release(need_release)
);

i2c_clock u_i2c_clock(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),

    .i2c_clk(i2c_clk)
);

endmodule