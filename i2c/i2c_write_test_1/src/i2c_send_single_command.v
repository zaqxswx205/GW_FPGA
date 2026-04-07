module i2c_send_single_command(
    input sys_clk,
    input sys_rst_n,
    
    output scl,
    input sda
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

reg [5:0] cur_state;
reg [5:0] next_state;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        cur_state <= IDLE;
    end
    else begin
        cur_state <= next_state;
    end
end

wire done;

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


//scl
reg scl_buf;
assign scl = scl_buf;

//sda三态设置，sda输出还是输入是由sda_in_en决定的，
//sda输出控制有两个来源，一个是顶层，一个是i2c_send_one_byte模块的输出
//当状态机在IDLE、START、STOP状态时，sda控制归顶层
//当状态机在ADDR、CONTROL_BYTE、COMMAND_BYTE状态时，sda控制归i2c_send_one_byte模块

reg sda_in_en;
wire sda_out;
wire sda_in;
reg top_sda_buf;
wire i2c_send_one_byte_sda;

assign sda = sda_in_en ? 1'bz : sda_out;
assign sda_in = sda;
assign sda_out = (cur_state == IDLE || cur_state == START || cur_state == STOP) ? top_sda_buf : i2c_send_one_byte_sda;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        scl_buf <= 1'b1;
        sda_in_en <= 1'b0;
        start <= 1'b0;
        write_one_sda <= 1'b1;
    end
    else begin
        case (cur_state)
            IDLE:begin
                write_one_sda <= 1'b1;
                scl_buf <= 1'b1;
                sda_in_en <= 1'b0;
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

i2c_clock u_i2c_clock(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),

    .i2c_clk(i2c_clk)
);

endmodule