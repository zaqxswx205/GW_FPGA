module i2c_single_cmd(
    input sys_clk,
    input sys_rst_n,

    output scl,
    inout sda
);

parameter CLK_FREQ     = 26'd27_000_000;
parameter I2C_FREQ     = 18'd250_000;

parameter IDLE         = 6'b00_0001;
parameter START        = 6'b00_0010;
parameter ADDR         = 6'b00_0100;
parameter CONTROL_BYTE = 6'b00_1000;
parameter COMMAND_BYTE = 6'b01_0000;
parameter STOP         = 6'b10_0000;

reg scl_buf;


wire sda_in;
reg sda_release;
assign sda = sda_release ? 1'b1 : 1'bz;
assign sda_in = sda;

wire [8:0] clk_divide;
assign  clk_divide = (CLK_FREQ/I2C_FREQ) >> 2'd2;

reg [5:0] cur_state;
reg [5:0] next_state;




endmodule