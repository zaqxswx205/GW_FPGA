module ili9488_ctrl (
    input  wire sys_clk,
    input  wire sys_rst_n,
    input  wire [3:0] digit_value,
    input  wire [8:0] digit_pos_x,
    input  wire [8:0] digit_pos_y,
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
localparam [8:0]  LCD_W        = 9'd320;
localparam [8:0]  LCD_H        = 9'd480;

// 5x7 bitmap font scale (1: 5x7, 2: 10x14)
localparam [3:0] FONT_SCALE  = 4'd2;
// Colors (RGB666 path, still uses 8-bit transfer values)
localparam [7:0] FG_R        = 8'h00; // foreground: black
localparam [7:0] FG_G        = 8'h00;
localparam [7:0] FG_B        = 8'h00;
localparam [7:0] BG_R        = 8'hFF; // background: white
localparam [7:0] BG_G        = 8'hFF;
localparam [7:0] BG_B        = 8'hFF;
localparam [8:0] FONT_W_PX   = 9'd5 * FONT_SCALE;
localparam [8:0] FONT_H_PX   = 9'd7 * FONT_SCALE;

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
reg [8:0]  pix_x;
reg [8:0]  pix_y;

wire in_digit_box;
wire digit_on;
wire [8:0] local_x;
wire [8:0] local_y;
wire [3:0] cell_x;
wire [3:0] cell_y;
wire [7:0] pix_r;
wire [7:0] pix_g;
wire [7:0] pix_b;

function digit_pixel_5x7;
    input [3:0] digit;
    input [3:0] x;
    input [3:0] y;
    reg   [4:0] row_bits;
    begin
        row_bits = 5'b00000;
        case (digit)
            4'd0: case (y)
                4'd0: row_bits = 5'b01110; 4'd1: row_bits = 5'b10001; 4'd2: row_bits = 5'b10011;
                4'd3: row_bits = 5'b10101; 4'd4: row_bits = 5'b11001; 4'd5: row_bits = 5'b10001;
                4'd6: row_bits = 5'b01110; default: row_bits = 5'b00000;
            endcase
            4'd1: case (y)
                4'd0: row_bits = 5'b00100; 4'd1: row_bits = 5'b01100; 4'd2: row_bits = 5'b00100;
                4'd3: row_bits = 5'b00100; 4'd4: row_bits = 5'b00100; 4'd5: row_bits = 5'b00100;
                4'd6: row_bits = 5'b01110; default: row_bits = 5'b00000;
            endcase
            4'd2: case (y)
                4'd0: row_bits = 5'b01110; 4'd1: row_bits = 5'b10001; 4'd2: row_bits = 5'b00001;
                4'd3: row_bits = 5'b00010; 4'd4: row_bits = 5'b00100; 4'd5: row_bits = 5'b01000;
                4'd6: row_bits = 5'b11111; default: row_bits = 5'b00000;
            endcase
            4'd3: case (y)
                4'd0: row_bits = 5'b11110; 4'd1: row_bits = 5'b00001; 4'd2: row_bits = 5'b00001;
                4'd3: row_bits = 5'b01110; 4'd4: row_bits = 5'b00001; 4'd5: row_bits = 5'b00001;
                4'd6: row_bits = 5'b11110; default: row_bits = 5'b00000;
            endcase
            4'd4: case (y)
                4'd0: row_bits = 5'b00010; 4'd1: row_bits = 5'b00110; 4'd2: row_bits = 5'b01010;
                4'd3: row_bits = 5'b10010; 4'd4: row_bits = 5'b11111; 4'd5: row_bits = 5'b00010;
                4'd6: row_bits = 5'b00010; default: row_bits = 5'b00000;
            endcase
            4'd5: case (y)
                4'd0: row_bits = 5'b11111; 4'd1: row_bits = 5'b10000; 4'd2: row_bits = 5'b11110;
                4'd3: row_bits = 5'b00001; 4'd4: row_bits = 5'b00001; 4'd5: row_bits = 5'b10001;
                4'd6: row_bits = 5'b01110; default: row_bits = 5'b00000;
            endcase
            4'd6: case (y)
                4'd0: row_bits = 5'b00110; 4'd1: row_bits = 5'b01000; 4'd2: row_bits = 5'b10000;
                4'd3: row_bits = 5'b11110; 4'd4: row_bits = 5'b10001; 4'd5: row_bits = 5'b10001;
                4'd6: row_bits = 5'b01110; default: row_bits = 5'b00000;
            endcase
            4'd7: case (y)
                4'd0: row_bits = 5'b11111; 4'd1: row_bits = 5'b00001; 4'd2: row_bits = 5'b00010;
                4'd3: row_bits = 5'b00100; 4'd4: row_bits = 5'b01000; 4'd5: row_bits = 5'b01000;
                4'd6: row_bits = 5'b01000; default: row_bits = 5'b00000;
            endcase
            4'd8: case (y)
                4'd0: row_bits = 5'b01110; 4'd1: row_bits = 5'b10001; 4'd2: row_bits = 5'b10001;
                4'd3: row_bits = 5'b01110; 4'd4: row_bits = 5'b10001; 4'd5: row_bits = 5'b10001;
                4'd6: row_bits = 5'b01110; default: row_bits = 5'b00000;
            endcase
            4'd9: case (y)
                4'd0: row_bits = 5'b01110; 4'd1: row_bits = 5'b10001; 4'd2: row_bits = 5'b10001;
                4'd3: row_bits = 5'b01111; 4'd4: row_bits = 5'b00001; 4'd5: row_bits = 5'b00010;
                4'd6: row_bits = 5'b01100; default: row_bits = 5'b00000;
            endcase
            default: row_bits = 5'b00000;
        endcase
        if ((x < 4'd5) && (y < 4'd7))
            digit_pixel_5x7 = row_bits[x];
        else
            digit_pixel_5x7 = 1'b0;
    end
endfunction

assign in_digit_box = (pix_x >= digit_pos_x) && (pix_x < (digit_pos_x + FONT_W_PX)) &&
                      (pix_y >= digit_pos_y) && (pix_y < (digit_pos_y + FONT_H_PX));
assign local_x = pix_x - digit_pos_x;
assign local_y = pix_y - digit_pos_y;
assign cell_x = local_x / FONT_SCALE;
assign cell_y = local_y / FONT_SCALE;
assign digit_on = in_digit_box && digit_pixel_5x7(digit_value, cell_x, cell_y);

assign pix_r = digit_on ? FG_R : BG_R;
assign pix_g = digit_on ? FG_G : BG_G;
assign pix_b = digit_on ? FG_B : BG_B;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        state      <= ST_RST_LOW;
        next_state <= ST_SPI_INIT;
        delay_cnt  <= 27'd0;
        seq_idx    <= 4'd0;
        pix_left   <= 18'd0;
        pix_x      <= 9'd0;
        pix_y      <= 9'd0;
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
                    pix_x     <= 9'd0;
                    pix_y     <= 9'd0;
                    delay_cnt <= TX_GAP_CYC;
                    next_state<= ST_PIX_HI;
                    state     <= ST_DELAY;
                end

                ST_PIX_HI: begin
                    drv_type  <= DATA_ONLY;
                    drv_cmd   <= pix_r; // R
                    drv_param <= 8'h00;
                    drv_en    <= 1'b1;
                    delay_cnt <= TX_GAP_CYC;
                    next_state<= ST_PIX_MID;
                    state     <= ST_DELAY;
                end

                ST_PIX_MID: begin
                    drv_type  <= DATA_ONLY;
                    drv_cmd   <= pix_g; // G
                    drv_param <= 8'h00;
                    drv_en    <= 1'b1;
                    delay_cnt <= TX_GAP_CYC;
                    next_state<= ST_PIX_LO;
                    state     <= ST_DELAY;
                end

                ST_PIX_LO: begin
                    drv_type  <= DATA_ONLY;
                    drv_cmd   <= pix_b; // B
                    drv_param <= 8'h00;
                    drv_en    <= 1'b1;
                    delay_cnt <= TX_GAP_CYC;
                    state     <= ST_DELAY;
                    if (pix_left == 18'd1) begin
                        next_state <= ST_HOLD;
                    end else begin
                        pix_left   <= pix_left - 18'd1;
                        if (pix_x == (LCD_W - 9'd1)) begin
                            pix_x <= 9'd0;
                            if (pix_y == (LCD_H - 9'd1)) begin
                                pix_y <= 9'd0;
                            end else begin
                                pix_y <= pix_y + 9'd1;
                            end
                        end else begin
                            pix_x <= pix_x + 9'd1;
                        end
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
