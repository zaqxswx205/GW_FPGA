module ili9488_ctrl (
    input  wire sys_clk,
    input  wire sys_rst_n,
    output wire spi_sclk,
    output wire spi_mosi,
    output wire spi_cs_n,
    output wire dcx,
    output reg  lcd_rst_n,
    output wire lcd_bl
);

localparam [2:0]
    CMD_ONLY  = 3'b000,
    INIT_CTRL = 3'b001,
    DATA_ONLY = 3'b010,
    CMD_PARAM = 3'b100;

localparam integer CLK_HZ      = 27_000_000;
localparam integer DLY_RST_LOW = CLK_HZ / 100; // 10ms
localparam integer DLY_RST_HI  = CLK_HZ / 100; // 10ms
localparam integer DLY_20MS    = CLK_HZ / 50;
localparam integer DLY_120MS   = (CLK_HZ * 12) / 100;
localparam integer TX_GAP_CYC  = 27'd80;

localparam [4:0]
    ST_RST_LOW  = 5'd0,
    ST_RST_HI   = 5'd1,
    ST_SPI_INIT = 5'd2,
    ST_SWRESET  = 5'd3,
    ST_SLPOUT   = 5'd4,
    ST_COLMOD   = 5'd5,
    ST_MADCTL   = 5'd6,
    ST_NORON    = 5'd7,
    ST_DISPON   = 5'd8,
    ST_CASET    = 5'd9,
    ST_PASET    = 5'd10,
    ST_RAMWR    = 5'd11,
    ST_PIX_HI   = 5'd12,
    ST_PIX_MID  = 5'd13,
    ST_PIX_LO   = 5'd14,
    ST_HOLD     = 5'd15,
    ST_DELAY    = 5'd16;

reg       drv_en;
reg [2:0] drv_type;
reg [7:0] drv_cmd;
reg [7:0] drv_param;
wire      drv_busy;
wire      drv_done;

assign lcd_bl = 1'b1;

reg [4:0]  state;
reg [4:0]  next_state;
reg [26:0] delay_cnt;
reg [3:0]  seq_idx;
reg [17:0] pix_left;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        state      <= ST_RST_LOW;
        next_state <= ST_SPI_INIT;
        delay_cnt  <= 27'd0;
        seq_idx    <= 4'd0;
        pix_left   <= 18'd0;
        drv_en     <= 1'b0;
        drv_type   <= CMD_ONLY;
        drv_cmd    <= 8'h00;
        drv_param  <= 8'h00;
        lcd_rst_n  <= 1'b0;
    end else begin
        drv_en <= 1'b0;

        if (delay_cnt != 27'd0) begin
            delay_cnt <= delay_cnt - 27'd1;
        end else begin
            case (state)
                ST_RST_LOW: begin
                    lcd_rst_n  <= 1'b0;
                    delay_cnt  <= DLY_RST_LOW;
                    next_state <= ST_RST_HI;
                    state      <= ST_DELAY;
                end

                ST_RST_HI: begin
                    lcd_rst_n  <= 1'b1;
                    delay_cnt  <= DLY_RST_HI;
                    next_state <= ST_SPI_INIT;
                    state      <= ST_DELAY;
                end

                ST_SPI_INIT: begin
                    drv_type  <= INIT_CTRL;
                    drv_cmd   <= 8'h00;
                    drv_param <= 8'h00;
                    drv_en    <= 1'b1;
                    delay_cnt <= DLY_20MS;
                    next_state<= ST_SWRESET;
                    state     <= ST_DELAY;
                end

                ST_SWRESET: begin
                    drv_type  <= CMD_ONLY;
                    drv_cmd   <= 8'h01;
                    drv_param <= 8'h00;
                    drv_en    <= 1'b1;
                    delay_cnt <= DLY_120MS;
                    next_state<= ST_SLPOUT;
                    state     <= ST_DELAY;
                end

                ST_SLPOUT: begin
                    drv_type  <= CMD_ONLY;
                    drv_cmd   <= 8'h11;
                    drv_param <= 8'h00;
                    drv_en    <= 1'b1;
                    delay_cnt <= DLY_120MS;
                    next_state<= ST_COLMOD;
                    state     <= ST_DELAY;
                end

                ST_COLMOD: begin
                    drv_type  <= CMD_PARAM;
                    drv_cmd   <= 8'h3A;
                    // Use 18-bit/pixel for ILI9488 serial write path (RGB666, 3 bytes/pixel).
                    drv_param <= 8'h66;
                    drv_en    <= 1'b1;
                    delay_cnt <= TX_GAP_CYC;
                    next_state<= ST_MADCTL;
                    state     <= ST_DELAY;
                end

                ST_MADCTL: begin
                    drv_type  <= CMD_PARAM;
                    drv_cmd   <= 8'h36;
                    // Keep portrait scan (no MV swap) and use BGR color order.
                    drv_param <= 8'h08;
                    drv_en    <= 1'b1;
                    delay_cnt <= TX_GAP_CYC;
                    next_state<= ST_NORON;
                    state     <= ST_DELAY;
                end

                ST_NORON: begin
                    drv_type  <= CMD_ONLY;
                    drv_cmd   <= 8'h13;
                    drv_param <= 8'h00;
                    drv_en    <= 1'b1;
                    delay_cnt <= TX_GAP_CYC;
                    next_state<= ST_DISPON;
                    state     <= ST_DELAY;
                end

                ST_DISPON: begin
                    drv_type  <= CMD_ONLY;
                    drv_cmd   <= 8'h29;
                    drv_param <= 8'h00;
                    drv_en    <= 1'b1;
                    delay_cnt <= DLY_20MS;
                    seq_idx   <= 4'd0;
                    next_state<= ST_CASET;
                    state     <= ST_DELAY;
                end

                ST_CASET: begin
                    case (seq_idx)
                        4'd0: begin drv_type <= CMD_ONLY;  drv_cmd <= 8'h2A; end
                        4'd1: begin drv_type <= DATA_ONLY; drv_cmd <= 8'h00; end
                        4'd2: begin drv_type <= DATA_ONLY; drv_cmd <= 8'h00; end
                        4'd3: begin drv_type <= DATA_ONLY; drv_cmd <= 8'h01; end
                        default: begin drv_type <= DATA_ONLY; drv_cmd <= 8'h3F; end
                    endcase
                    drv_param <= 8'h00;
                    drv_en    <= 1'b1;
                    delay_cnt <= TX_GAP_CYC;
                    state     <= ST_DELAY;
                    if (seq_idx == 4'd4) begin
                        seq_idx    <= 4'd0;
                        next_state <= ST_PASET;
                    end else begin
                        seq_idx    <= seq_idx + 4'd1;
                        next_state <= ST_CASET;
                    end
                end

                ST_PASET: begin
                    case (seq_idx)
                        4'd0: begin drv_type <= CMD_ONLY;  drv_cmd <= 8'h2B; end
                        4'd1: begin drv_type <= DATA_ONLY; drv_cmd <= 8'h00; end
                        4'd2: begin drv_type <= DATA_ONLY; drv_cmd <= 8'h00; end
                        4'd3: begin drv_type <= DATA_ONLY; drv_cmd <= 8'h01; end
                        default: begin drv_type <= DATA_ONLY; drv_cmd <= 8'hDF; end
                    endcase
                    drv_param <= 8'h00;
                    drv_en    <= 1'b1;
                    delay_cnt <= TX_GAP_CYC;
                    state     <= ST_DELAY;
                    if (seq_idx == 4'd4) begin
                        seq_idx    <= 4'd0;
                        next_state <= ST_RAMWR;
                    end else begin
                        seq_idx    <= seq_idx + 4'd1;
                        next_state <= ST_PASET;
                    end
                end

                ST_RAMWR: begin
                    drv_type  <= CMD_ONLY;
                    drv_cmd   <= 8'h2C;
                    drv_param <= 8'h00;
                    drv_en    <= 1'b1;
                    pix_left  <= 18'd153600; // 320*480
                    delay_cnt <= TX_GAP_CYC;
                    next_state<= ST_PIX_HI;
                    state     <= ST_DELAY;
                end

                ST_PIX_HI: begin
                    drv_type  <= DATA_ONLY;
                    drv_cmd   <= 8'h00; // R
                    drv_param <= 8'h00;
                    drv_en    <= 1'b1;
                    delay_cnt <= TX_GAP_CYC;
                    next_state<= ST_PIX_MID;
                    state     <= ST_DELAY;
                end

                ST_PIX_MID: begin
                    drv_type  <= DATA_ONLY;
                    drv_cmd   <= 8'h00; // G
                    drv_param <= 8'h00;
                    drv_en    <= 1'b1;
                    delay_cnt <= TX_GAP_CYC;
                    next_state<= ST_PIX_LO;
                    state     <= ST_DELAY;
                end

                ST_PIX_LO: begin
                    drv_type  <= DATA_ONLY;
                    drv_cmd   <= 8'hFF; // B
                    drv_param <= 8'h00;
                    drv_en    <= 1'b1;
                    delay_cnt <= TX_GAP_CYC;
                    state     <= ST_DELAY;
                    if (pix_left == 18'd1) begin
                        next_state <= ST_HOLD;
                    end else begin
                        pix_left   <= pix_left - 18'd1;
                        next_state <= ST_PIX_HI;
                    end
                end

                ST_HOLD: begin
                    state <= ST_HOLD;
                end

                ST_DELAY: begin
                    if (!drv_busy) state <= next_state;
                end

                default: state <= ST_RST_LOW;
            endcase
        end
    end
end

spi_driver u_spi_driver (
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .en(drv_en),
    .command_type(drv_type),
    .command(drv_cmd),
    .param(drv_param),
    .dcx(dcx),
    .spi_sclk(spi_sclk),
    .spi_mosi(spi_mosi),
    .spi_cs_n(spi_cs_n),
    .busy(drv_busy),
    .done(drv_done)
);

endmodule
