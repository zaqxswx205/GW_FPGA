module spi_driver (
    input  wire sys_clk,
    input  wire sys_rst_n,

	input en,
	input [2:0] command_type,
	input [7:0] command,
	input [7:0] param,
    output reg  dcx,
    output wire spi_sclk,
    output wire spi_mosi
);

localparam [2:0]
    SPI_REG_TX     = 3'h1,
    SPI_REG_CTRL   = 3'h3,
	SPI_REG_STATUS = 3'h2;

localparam [7:0] CTRL_CFG       = 8'h00; // Table 3-9: all irq disable, SSO=0

localparam [5:0]
    SPI_IDLE           = 6'b00_0001 << 0,//01
	SPI_INIT           = 6'b00_0001 << 1,//02
	SPI_LOAD_PAYLOAD   = 6'b00_0001 << 2,//04
	SPI_LOAD_PARAMETER = 6'b00_0001 << 3,//08
	SPI_WAIT_DONE      = 6'b00_0001 << 4,//10
	SPI_DONE           = 6'b00_0001 << 5;

//SPI_MASTER_Top signals
reg       I_TX_EN;
reg [2:0] I_WADDR;
reg [7:0] I_WDATA;
reg       I_RX_EN;
reg [2:0] I_RADDR;
wire [7:0] O_RDATA;

reg [5:0] state;
reg tx_started;

always @(posedge sys_clk or negedge sys_rst_n) begin
	if (!sys_rst_n) begin
		state <= SPI_IDLE;
		I_TX_EN <= 1'b0;
		I_WADDR <= 3'b000;
		I_WDATA <= 8'h00;
		I_RX_EN <= 1'b0;
		I_RADDR <= 3'b000;
		dcx <= 1'b0;
		tx_started <= 1'b0;
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
				dcx <= 1'b0;
				I_RADDR <= SPI_REG_STATUS;
				if (en && O_RDATA[4])begin
					state <= (command_type == 3'b001) ? SPI_INIT : SPI_LOAD_PAYLOAD;
				end
				else state <= SPI_IDLE;
			end
			SPI_INIT:begin
				I_TX_EN <= 1'b1;
				I_WADDR <= SPI_REG_CTRL;
				I_WDATA <= CTRL_CFG;
				dcx <= 1'b0;
				state <= SPI_DONE;
			end
			SPI_LOAD_PAYLOAD:begin
				I_TX_EN <= 1'b1;
				I_WADDR <= SPI_REG_TX;
				I_WDATA <= command;
				dcx <= 1'b0;
				tx_started <= 1'b0;
				state <= SPI_WAIT_DONE;
			end
			SPI_LOAD_PARAMETER:begin
				I_TX_EN <= 1'b1;
				I_WADDR <= SPI_REG_TX;
				I_WDATA <= param;
				dcx <= 1'b1;
				tx_started <= 1'b0;
				state <= SPI_WAIT_DONE;
			end
			SPI_WAIT_DONE:begin
				I_RX_EN <= 1'b1;
				I_RADDR <= SPI_REG_STATUS;
				// Wait until TMT first goes low (transfer started), then high (done).
				if (tx_started == 1'b0) begin
					if (O_RDATA[4] == 1'b0) tx_started <= 1'b1;
					state <= SPI_WAIT_DONE;
				end else begin
					if (O_RDATA[4])begin
						if (dcx) state <= SPI_DONE;
						else state <= (command_type == 3'b100) ? SPI_LOAD_PARAMETER : SPI_DONE;
					end else state <= SPI_WAIT_DONE;
				end
			end
			SPI_DONE:begin
				dcx <= 1'b0;
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
