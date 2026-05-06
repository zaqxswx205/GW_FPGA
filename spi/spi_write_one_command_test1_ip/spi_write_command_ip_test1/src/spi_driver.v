module spi_driver (
    input  wire sys_clk,
    input  wire sys_rst_n,

	input en,
	input [2:0] command_type,
    output reg  dc,
    output wire spi_sclk,
    output wire spi_mosi
);

localparam [2:0]
    SPI_REG_TX     = 3'h1,
    SPI_REG_CTRL   = 3'h3,
	SPI_REG_STATUS = 3'h2;

localparam [7:0] CMD_BYTE       = 8'h11;
localparam [7:0] CTRL_CFG       = 8'h00; // Table 3-9: all irq disable, SSO=0

localparam [4:0]
    SPI_IDLE         = 5'b00001,
	SPI_INIT         = 5'b00010,
	SPI_LOAD_PAYLOAD = 5'b00100,
	SPI_WAIT_DONE    = 5'b01000,
	SPI_DONE         = 5'b10000;

//SPI_MASTER_Top signals
reg       I_TX_EN;
reg [2:0] I_WADDR;
reg [7:0] I_WDATA;
reg       I_RX_EN;
reg [2:0] I_RADDR;
wire [7:0] O_RDATA;

reg [4:0] state;

always @(posedge sys_clk or negedge sys_rst_n) begin
	if (!sys_rst_n) begin
		state <= SPI_IDLE;
		I_TX_EN <= 1'b0;
		I_WADDR <= 3'b000;
		I_WDATA <= 8'h00;
		I_RX_EN <= 1'b0;
		I_RADDR <= 3'b000;
	end
	else begin
		I_TX_EN <= 1'b0;
		I_RX_EN <= 1'b0;
		case (state)
			SPI_IDLE:begin
				I_TX_EN <= 1'b0;
				I_WADDR <= 3'b000;
				I_WDATA <= 8'h00;
				I_RX_EN <= 1'b1;
				I_RADDR <= SPI_REG_STATUS;
				if (en && O_RDATA[5])begin
					case (command_type)
						3'b001: state <= SPI_INIT;
						3'b010: state <= SPI_LOAD_PAYLOAD;
						3'b100: state <= SPI_DONE;
						default: state <= SPI_IDLE;
					endcase
				end
				else state <= SPI_IDLE;
			end
			SPI_INIT:begin
				I_TX_EN <= 1'b1;
				I_WADDR <= SPI_REG_CTRL;
				I_WDATA <= CTRL_CFG;
				state <= SPI_DONE;
			end
			SPI_LOAD_PAYLOAD:begin
				I_TX_EN <= 1'b1;
				I_WADDR <= SPI_REG_TX;
				I_WDATA <= CMD_BYTE;
				state <= SPI_WAIT_DONE;
			end
			SPI_WAIT_DONE:begin
				I_RX_EN <= 1'b1;
				I_RADDR <= SPI_REG_STATUS;
				state <= (O_RDATA[5]) ? SPI_DONE : SPI_WAIT_DONE;
			end
			SPI_DONE:begin
				state <= SPI_IDLE;
			end
			default:begin
				state <= SPI_IDLE;
			end
		endcase
	end
end


SPI_MASTER_Top your_instance_name(
	.I_CLK(sys_clk), //input I_CLK
	.I_RESETN(sys_rst_n), //input I_RESETN
	.I_TX_EN(I_TX_EN), //input I_TX_EN
	.I_WADDR(I_WADDR), //input [2:0] I_WADDR
	.I_WDATA(I_WDATA), //input [7:0] I_WDATA
	.I_RX_EN(I_RX_EN), //input I_RX_EN
	.I_RADDR(I_RADDR), //input [2:0] I_RADDR
	.O_RDATA(O_RDATA), //output [7:0] O_RDATA
	.O_SPI_INT(), //output O_SPI_INT
	.MISO_MASTER(1'b0), //input MISO_MASTER
	.MOSI_MASTER(spi_mosi), //output MOSI_MASTER
	.SS_N_MASTER(), //output [0:0] SS_N_MASTER
	.SCLK_MASTER(spi_sclk), //output SCLK_MASTER
	.MISO_SLAVE(), //output MISO_SLAVE
	.MOSI_SLAVE(1'b0), //input MOSI_SLAVE
	.SS_N_SLAVE(1'b0), //input SS_N_SLAVE
	.SCLK_SLAVE(1'b0) //input SCLK_SLAVE
);

endmodule
