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

reg [5:0] cur_state;
reg [5:0] next_state;

wire done_buf;
reg done_d;
wire done;

always @(posedge sys_clk or negedge sys_rst_n) begin
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
        cur_state <= next_state;
    end
end

always @(*) begin
    case (cur_state)
        IDLE:next_state = START;
        START:next_state = (!sda) ? ADDR : START;
        ADDR:next_state = (done) ? CONTROL_BYTE : ADDR;
        CONTROL_BYTE:next_state = (done) ? COMMAND_BYTE : CONTROL_BYTE;
        COMMAND_BYTE:next_state = (done) ? STOP : COMMAND_BYTE;
        STOP:next_state = IDLE;
        default:next_state = IDLE;
    endcase
end

reg [3:0] bit_cnt;
reg [7:0] data;
wire send_scl;
wire need_release;
wire send_sda;
reg start;

reg scl_buf;
wire sda_out;
reg sda_out_buf;
reg write_one_sda;
reg sda_in_en;
reg sda_en;
wire sda_in;

assign scl = scl_buf;
assign sda = sda_in_en ? 1'bz : sda_out;//1'bz 是高阻态 0是输出
assign sda_in = sda;
assign sda_out = (cur_state == IDLE || cur_state == START || cur_state == STOP) ? write_one_sda : send_sda;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        scl_buf <= 1'b1;
        sda_in_en <= 1'b0;
        bit_cnt <= 4'd0;
        start <= 1'b0;
        write_one_sda <= 1'b1;
    end
    else begin
        case (cur_state)
            IDLE:begin
                write_one_sda <= 1'b1;
                scl_buf <= 1'b1;
                sda_in_en <= 1'b0;
                bit_cnt <= 4'd0;
                start <= 1'b0;
            end
            START:begin
                sda_in_en <= 1'b0;
                write_one_sda <= 1'b0;
            end
            ADDR:begin
                data <= I2C_ADDR;
                start <= 1'b1;
                scl_buf <= send_scl;
                sda_in_en <= need_release;
            end
            CONTROL_BYTE:begin
                data <= CONTROL;
                start <= 1'b1;
                scl_buf <= send_scl;
                sda_in_en <= need_release;
            end
            COMMAND_BYTE:begin
                data <= COMMAND;
                start <= 1'b1;
                scl_buf <= send_scl;
                sda_in_en <= need_release;
            end
            STOP:begin
                start <= 1'b0;
                scl_buf <= 1'b1;
                sda_in_en <= 1'b0;
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