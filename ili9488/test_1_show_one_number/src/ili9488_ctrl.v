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
localparam integer TX_GAP_CYC  = 27'd80; // slow down effective byte rate (~3us gap @27MHz)

localparam [5:0]
    ST_RST_LOW    = 6'd0,
    ST_RST_HIGH   = 6'd1,
    ST_SPI_INIT   = 6'd2,
    ST_DELAY      = 6'd3,
    ST_SWRESET    = 6'd4,
    ST_SLPOUT     = 6'd5,
    ST_COLMOD     = 6'd6,
    ST_MADCTL     = 6'd7,
    ST_NORON      = 6'd8,
    ST_DISPON     = 6'd9,
    ST_CASET_CMD  = 6'd10,
    ST_CASET_B0   = 6'd11,
    ST_CASET_B1   = 6'd12,
    ST_CASET_B2   = 6'd13,
    ST_CASET_B3   = 6'd14,
    ST_PASET_CMD  = 6'd15,
    ST_PASET_B0   = 6'd16,
    ST_PASET_B1   = 6'd17,
    ST_PASET_B2   = 6'd18,
    ST_PASET_B3   = 6'd19,
    ST_RAMWR      = 6'd20,
    ST_PIXELS     = 6'd21;

reg       drv_en;
reg [2:0] drv_type;
reg [7:0] drv_cmd;
reg [7:0] drv_param;
wire      drv_busy;
wire      drv_done;

assign lcd_bl = 1'b1;

reg [5:0]  state;
reg [5:0]  next_state;
reg [26:0] wait_cnt;

reg [8:0]  x;
reg [8:0]  y;
reg        byte_sel;
reg        frame_white;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        state       <= ST_RST_LOW;
        next_state  <= ST_SWRESET;
        wait_cnt    <= 27'd0;
        x           <= 9'd0;
        y           <= 9'd0;
        byte_sel    <= 1'b0;
        frame_white <= 1'b0;
        drv_en      <= 1'b0;
        drv_type    <= CMD_ONLY;
        drv_cmd     <= 8'h00;
        drv_param   <= 8'h00;
        lcd_rst_n   <= 1'b0;
    end else begin
        drv_en <= 1'b0;

        if (wait_cnt != 27'd0) begin
            wait_cnt <= wait_cnt - 27'd1;
        end else begin
            case (state)
                ST_RST_LOW: begin
                    lcd_rst_n <= 1'b0;
                    wait_cnt  <= DLY_RST_LOW;
                    state     <= ST_DELAY;
                    next_state<= ST_RST_HIGH;
                end

                ST_RST_HIGH: begin
                    lcd_rst_n <= 1'b1;
                    wait_cnt  <= DLY_RST_HI;
                    state     <= ST_DELAY;
                    next_state<= ST_SPI_INIT;
                end

                ST_SPI_INIT: begin
                    drv_type  <= INIT_CTRL;
                    drv_cmd   <= 8'h00;
                    drv_param <= 8'h00;
                    drv_en    <= 1'b1;
                    wait_cnt  <= TX_GAP_CYC;
                    state     <= ST_DELAY;
                    next_state<= ST_SWRESET;
                end

                ST_DELAY: begin
                    state <= next_state;
                end

                ST_SWRESET: begin
                    drv_type  <= CMD_ONLY;
                    drv_cmd   <= 8'h01;
                    drv_param <= 8'h00;
                    drv_en    <= 1'b1;
                    wait_cnt  <= DLY_120MS;
                    state     <= ST_DELAY;
                    next_state<= ST_SLPOUT;
                end

                ST_SLPOUT: begin
                    drv_type  <= CMD_ONLY;
                    drv_cmd   <= 8'h11;
                    drv_param <= 8'h00;
                    drv_en    <= 1'b1;
                    wait_cnt  <= DLY_120MS;
                    state     <= ST_DELAY;
                    next_state<= ST_COLMOD;
                end

                ST_COLMOD: begin
                    drv_type  <= CMD_PARAM;
                    drv_cmd   <= 8'h3A;
                    drv_param <= 8'h55;
                    drv_en    <= 1'b1;
                    wait_cnt  <= TX_GAP_CYC;
                    state     <= ST_DELAY;
                    next_state<= ST_MADCTL;
                end

                ST_MADCTL: begin
                    drv_type  <= CMD_PARAM;
                    drv_cmd   <= 8'h36;
                    drv_param <= 8'h28;
                    drv_en    <= 1'b1;
                    wait_cnt  <= TX_GAP_CYC;
                    state     <= ST_DELAY;
                    next_state<= ST_NORON;
                end

                ST_NORON: begin
                    drv_type  <= CMD_ONLY;
                    drv_cmd   <= 8'h13;
                    drv_param <= 8'h00;
                    drv_en    <= 1'b1;
                    wait_cnt  <= TX_GAP_CYC;
                    state     <= ST_DELAY;
                    next_state<= ST_DISPON;
                end

                ST_DISPON: begin
                    drv_type  <= CMD_ONLY;
                    drv_cmd   <= 8'h29;
                    drv_param <= 8'h00;
                    drv_en    <= 1'b1;
                    wait_cnt  <= DLY_20MS;
                    state     <= ST_DELAY;
                    next_state<= ST_CASET_CMD;
                end

                ST_CASET_CMD: begin drv_type<=CMD_ONLY;  drv_cmd<=8'h2A; drv_param<=8'h00; drv_en<=1'b1; wait_cnt<=TX_GAP_CYC; state<=ST_DELAY; next_state<=ST_CASET_B0; end
                ST_CASET_B0:  begin drv_type<=DATA_ONLY; drv_cmd<=8'h00; drv_param<=8'h00; drv_en<=1'b1; wait_cnt<=TX_GAP_CYC; state<=ST_DELAY; next_state<=ST_CASET_B1; end
                ST_CASET_B1:  begin drv_type<=DATA_ONLY; drv_cmd<=8'h00; drv_param<=8'h00; drv_en<=1'b1; wait_cnt<=TX_GAP_CYC; state<=ST_DELAY; next_state<=ST_CASET_B2; end
                ST_CASET_B2:  begin drv_type<=DATA_ONLY; drv_cmd<=8'h01; drv_param<=8'h00; drv_en<=1'b1; wait_cnt<=TX_GAP_CYC; state<=ST_DELAY; next_state<=ST_CASET_B3; end
                ST_CASET_B3:  begin drv_type<=DATA_ONLY; drv_cmd<=8'h3F; drv_param<=8'h00; drv_en<=1'b1; wait_cnt<=TX_GAP_CYC; state<=ST_DELAY; next_state<=ST_PASET_CMD; end

                ST_PASET_CMD: begin drv_type<=CMD_ONLY;  drv_cmd<=8'h2B; drv_param<=8'h00; drv_en<=1'b1; wait_cnt<=TX_GAP_CYC; state<=ST_DELAY; next_state<=ST_PASET_B0; end
                ST_PASET_B0:  begin drv_type<=DATA_ONLY; drv_cmd<=8'h00; drv_param<=8'h00; drv_en<=1'b1; wait_cnt<=TX_GAP_CYC; state<=ST_DELAY; next_state<=ST_PASET_B1; end
                ST_PASET_B1:  begin drv_type<=DATA_ONLY; drv_cmd<=8'h00; drv_param<=8'h00; drv_en<=1'b1; wait_cnt<=TX_GAP_CYC; state<=ST_DELAY; next_state<=ST_PASET_B2; end
                ST_PASET_B2:  begin drv_type<=DATA_ONLY; drv_cmd<=8'h01; drv_param<=8'h00; drv_en<=1'b1; wait_cnt<=TX_GAP_CYC; state<=ST_DELAY; next_state<=ST_PASET_B3; end
                ST_PASET_B3:  begin drv_type<=DATA_ONLY; drv_cmd<=8'hDF; drv_param<=8'h00; drv_en<=1'b1; wait_cnt<=TX_GAP_CYC; state<=ST_DELAY; next_state<=ST_RAMWR; end

                ST_RAMWR: begin
                    drv_type  <= CMD_ONLY;
                    drv_cmd   <= 8'h2C;
                    drv_param <= 8'h00;
                    drv_en    <= 1'b1;
                    x         <= 9'd0;
                    y         <= 9'd0;
                    byte_sel  <= 1'b0;
                    wait_cnt  <= TX_GAP_CYC;
                    state     <= ST_PIXELS;
                end

                ST_PIXELS: begin
                    drv_type <= DATA_ONLY;
                    if (frame_white) begin
                        drv_cmd <= 8'hFF; // white: FFFF
                    end else begin
                        drv_cmd <= byte_sel ? 8'h1F : 8'h00; // blue: 001F
                    end
                    drv_param <= 8'h00;
                    drv_en    <= 1'b1;
                    wait_cnt  <= TX_GAP_CYC;

                    if (!byte_sel) begin
                        byte_sel <= 1'b1;
                    end else begin
                        byte_sel <= 1'b0;
                        if (x == 9'd319) begin
                            x <= 9'd0;
                            if (y == 9'd479) begin
                                frame_white <= ~frame_white;
                                state <= ST_RAMWR;
                            end else begin
                                y <= y + 9'd1;
                            end
                        end else begin
                            x <= x + 9'd1;
                        end
                    end
                end

                default: begin
                    state <= ST_RST_LOW;
                end
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
