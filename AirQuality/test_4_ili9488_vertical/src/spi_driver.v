module spi_driver (
    input  wire sys_clk,
    input  wire sys_rst_n,

    input  wire en,
    input  wire [2:0] command_type,
    input  wire [7:0] command,
    input  wire [7:0] param,
    output reg  dcx,
    output wire spi_sclk,
    output wire spi_mosi,
    output wire spi_cs_n,
    output wire busy,
    output wire done
);

localparam [2:0]
    SPI_REG_TX     = 3'h1,
    SPI_REG_CTRL   = 3'h3,
    SPI_REG_STATUS = 3'h2;

localparam [7:0] CTRL_CFG = 8'h00;

localparam [2:0]
    CMD_ONLY  = 3'b000,
    INIT_CTRL = 3'b001,
    DATA_ONLY = 3'b010,
    CMD_PARAM = 3'b100;

localparam [5:0]
    SPI_IDLE           = 6'b00_0001 << 0,
    SPI_INIT           = 6'b00_0001 << 1,
    SPI_LOAD_PAYLOAD   = 6'b00_0001 << 2,
    SPI_LOAD_PARAMETER = 6'b00_0001 << 3,
    SPI_WAIT_DONE      = 6'b00_0001 << 4,
    SPI_DONE           = 6'b00_0001 << 5;

reg       I_TX_EN;
reg [2:0] I_WADDR;
reg [7:0] I_WDATA;
reg       I_RX_EN;
reg [2:0] I_RADDR;
wire [7:0] O_RDATA;
wire [0:0] ss_n_master;

reg [5:0] state;
reg tx_started;
reg send_data_phase;

assign busy = (state != SPI_IDLE);
assign done = (state == SPI_DONE);

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
        send_data_phase <= 1'b0;
    end else begin
        I_TX_EN <= 1'b0;
        I_RX_EN <= 1'b0;
        case (state)
            SPI_IDLE: begin
                I_RADDR <= SPI_REG_STATUS;
                I_RX_EN <= 1'b1;
                tx_started <= 1'b0;
                send_data_phase <= 1'b0;
                if (en && O_RDATA[4]) begin
                    if (command_type == INIT_CTRL) state <= SPI_INIT;
                    else if (command_type == DATA_ONLY) state <= SPI_LOAD_PARAMETER;
                    else state <= SPI_LOAD_PAYLOAD;
                end
            end

            SPI_INIT: begin
                I_TX_EN <= 1'b1;
                I_WADDR <= SPI_REG_CTRL;
                I_WDATA <= CTRL_CFG;
                dcx <= 1'b0;
                state <= SPI_DONE;
            end

            SPI_LOAD_PAYLOAD: begin
                I_TX_EN <= 1'b1;
                I_WADDR <= SPI_REG_TX;
                I_WDATA <= command;
                dcx <= 1'b0;
                tx_started <= 1'b0;
                send_data_phase <= 1'b0;
                state <= SPI_WAIT_DONE;
            end

            SPI_LOAD_PARAMETER: begin
                I_TX_EN <= 1'b1;
                I_WADDR <= SPI_REG_TX;
                I_WDATA <= (command_type == DATA_ONLY) ? command : param;
                dcx <= 1'b1;
                tx_started <= 1'b0;
                send_data_phase <= 1'b1;
                state <= SPI_WAIT_DONE;
            end

            SPI_WAIT_DONE: begin
                I_RX_EN <= 1'b1;
                I_RADDR <= SPI_REG_STATUS;
                if (tx_started == 1'b0) begin
                    if (O_RDATA[4] == 1'b0) tx_started <= 1'b1;
                end else begin
                    if (O_RDATA[4]) begin
                        if ((command_type == CMD_PARAM) && (send_data_phase == 1'b0)) begin
                            state <= SPI_LOAD_PARAMETER;
                        end else begin
                            state <= SPI_DONE;
                        end
                    end
                end
            end

            SPI_DONE: begin
                state <= SPI_IDLE;
            end

            default: state <= SPI_IDLE;
        endcase
    end
end

SPI_MASTER_Top your_instance_name(
    .I_CLK(sys_clk),
    .I_RESETN(sys_rst_n),
    .I_TX_EN(I_TX_EN),
    .I_WADDR(I_WADDR),
    .I_WDATA(I_WDATA),
    .I_RX_EN(I_RX_EN),
    .I_RADDR(I_RADDR),
    .O_RDATA(O_RDATA),
    .O_SPI_INT(),
    .MISO_MASTER(1'b0),
    .MOSI_MASTER(spi_mosi),
    .SS_N_MASTER(ss_n_master),
    .SCLK_MASTER(spi_sclk),
    .MISO_SLAVE(),
    .MOSI_SLAVE(1'b0),
    .SS_N_SLAVE(1'b0),
    .SCLK_SLAVE(1'b0)
);

// Keep CS asserted for the whole command/data stream.
assign spi_cs_n = 1'b0;

endmodule
