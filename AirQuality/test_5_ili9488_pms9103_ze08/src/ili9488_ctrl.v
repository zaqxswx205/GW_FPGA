module ili9488_ctrl (
    input  wire sys_clk,
    input  wire sys_rst_n,
    input  wire sensor_update,
    input  wire [15:0] pm1_cf1,
    input  wire [15:0] pm25_cf1,
    input  wire [15:0] pm10_cf1,
    input  wire [15:0] pcnt_03,
    input  wire [15:0] pcnt_05,
    input  wire [15:0] pcnt_10,
    input  wire [15:0] ch2o,
    input  wire [15:0] co2,
    input  wire [15:0] voc,
    output wire spi_sclk,
    output wire spi_mosi,
    output wire spi_cs_n,
    output wire dcx,
    output reg  lcd_rst_n,
    output wire lcd_bl,
    output reg  sensor_update_ack
);

localparam [2:0] CMD_ONLY=3'b000, INIT_CTRL=3'b001, DATA_ONLY=3'b010, CMD_PARAM=3'b100;

localparam integer CLK_HZ      = 27_000_000;
localparam integer DLY_RST_LOW = CLK_HZ / 100;
localparam integer DLY_RST_HI  = CLK_HZ / 100;
localparam integer DLY_20MS    = CLK_HZ / 50;
localparam integer DLY_120MS   = (CLK_HZ * 12) / 100;
localparam integer TX_GAP_CYC  = 27'd80;
localparam [8:0]  LCD_W        = 9'd480;
localparam [8:0]  LCD_H        = 9'd320;
localparam [8:0]  LCD_WM1      = 9'd479;
localparam [8:0]  LCD_HM1      = 9'd319;

localparam [3:0] FONT_SCALE = 4'd2;
localparam [8:0] CHAR_W = 9'd5 * FONT_SCALE;
localparam [8:0] CHAR_H = 9'd7 * FONT_SCALE;
localparam [8:0] CHAR_ADV = CHAR_W + FONT_SCALE;
localparam [8:0] ROW_STEP = 9'd30;
localparam [8:0] TITLE_Y  = 9'd8;
localparam [8:0] LIST_Y0  = 9'd24;
localparam [8:0] LABEL_X  = 9'd20;
localparam [8:0] VALUE_X  = 9'd240;
localparam [8:0] UNIT_X   = 9'd330;

localparam [7:0] FG_R = 8'h00, FG_G = 8'h00, FG_B = 8'h00;
localparam [7:0] BG_R = 8'hFF, BG_G = 8'hFF, BG_B = 8'hFF;

localparam [4:0]
    ST_RST_LOW  = 5'd0, ST_RST_HI   = 5'd1, ST_SPI_INIT = 5'd2, ST_SWRESET  = 5'd3,
    ST_SLPOUT   = 5'd4, ST_COLMOD   = 5'd5, ST_MADCTL   = 5'd6, ST_NORON    = 5'd7,
    ST_DISPON   = 5'd8, ST_CASET    = 5'd9, ST_PASET    = 5'd10,ST_RAMWR    = 5'd11,
    ST_PIX_HI   = 5'd12,ST_PIX_MID  = 5'd13,ST_PIX_LO   = 5'd14,ST_HOLD     = 5'd15,
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

reg [15:0] v_pm1_cf1, v_pm25_cf1, v_pm10_cf1, v_pcnt_03, v_pcnt_05, v_pcnt_10, v_ch2o, v_co2, v_voc;

wire pixel_on;
wire [7:0] pix_r = pixel_on ? FG_R : BG_R;
wire [7:0] pix_g = pixel_on ? FG_G : BG_G;
wire [7:0] pix_b = pixel_on ? FG_B : BG_B;

function [4:0] glyph_row;
    input [7:0] ch;
    input [2:0] y;
    begin
        glyph_row = 5'b00000;
        case (ch)
            "0": case(y) 0:glyph_row=5'b01110;1:glyph_row=5'b10001;2:glyph_row=5'b10011;3:glyph_row=5'b10101;4:glyph_row=5'b11001;5:glyph_row=5'b10001;6:glyph_row=5'b01110; endcase
            "1": case(y) 0:glyph_row=5'b00100;1:glyph_row=5'b01100;2:glyph_row=5'b00100;3:glyph_row=5'b00100;4:glyph_row=5'b00100;5:glyph_row=5'b00100;6:glyph_row=5'b01110; endcase
            "2": case(y) 0:glyph_row=5'b01110;1:glyph_row=5'b10001;2:glyph_row=5'b00001;3:glyph_row=5'b00010;4:glyph_row=5'b00100;5:glyph_row=5'b01000;6:glyph_row=5'b11111; endcase
            "3": case(y) 0:glyph_row=5'b11110;1:glyph_row=5'b00001;2:glyph_row=5'b00001;3:glyph_row=5'b01110;4:glyph_row=5'b00001;5:glyph_row=5'b00001;6:glyph_row=5'b11110; endcase
            "4": case(y) 0:glyph_row=5'b00010;1:glyph_row=5'b00110;2:glyph_row=5'b01010;3:glyph_row=5'b10010;4:glyph_row=5'b11111;5:glyph_row=5'b00010;6:glyph_row=5'b00010; endcase
            "5": case(y) 0:glyph_row=5'b11111;1:glyph_row=5'b10000;2:glyph_row=5'b11110;3:glyph_row=5'b00001;4:glyph_row=5'b00001;5:glyph_row=5'b10001;6:glyph_row=5'b01110; endcase
            "6": case(y) 0:glyph_row=5'b00110;1:glyph_row=5'b01000;2:glyph_row=5'b10000;3:glyph_row=5'b11110;4:glyph_row=5'b10001;5:glyph_row=5'b10001;6:glyph_row=5'b01110; endcase
            "7": case(y) 0:glyph_row=5'b11111;1:glyph_row=5'b00001;2:glyph_row=5'b00010;3:glyph_row=5'b00100;4:glyph_row=5'b01000;5:glyph_row=5'b01000;6:glyph_row=5'b01000; endcase
            "8": case(y) 0:glyph_row=5'b01110;1:glyph_row=5'b10001;2:glyph_row=5'b10001;3:glyph_row=5'b01110;4:glyph_row=5'b10001;5:glyph_row=5'b10001;6:glyph_row=5'b01110; endcase
            "9": case(y) 0:glyph_row=5'b01110;1:glyph_row=5'b10001;2:glyph_row=5'b10001;3:glyph_row=5'b01111;4:glyph_row=5'b00001;5:glyph_row=5'b00010;6:glyph_row=5'b01100; endcase
            "P": case(y) 0:glyph_row=5'b11110;1:glyph_row=5'b10001;2:glyph_row=5'b10001;3:glyph_row=5'b11110;4:glyph_row=5'b10000;5:glyph_row=5'b10000;6:glyph_row=5'b10000; endcase
            "B": case(y) 0:glyph_row=5'b11110;1:glyph_row=5'b10001;2:glyph_row=5'b10001;3:glyph_row=5'b11110;4:glyph_row=5'b10001;5:glyph_row=5'b10001;6:glyph_row=5'b11110; endcase
            "M": case(y) 0:glyph_row=5'b10001;1:glyph_row=5'b11011;2:glyph_row=5'b10101;3:glyph_row=5'b10101;4:glyph_row=5'b10001;5:glyph_row=5'b10001;6:glyph_row=5'b10001; endcase
            "U": case(y) 0:glyph_row=5'b10001;1:glyph_row=5'b10001;2:glyph_row=5'b10001;3:glyph_row=5'b10001;4:glyph_row=5'b10001;5:glyph_row=5'b10001;6:glyph_row=5'b01110; endcase
            "C": case(y) 0:glyph_row=5'b01110;1:glyph_row=5'b10001;2:glyph_row=5'b10000;3:glyph_row=5'b10000;4:glyph_row=5'b10000;5:glyph_row=5'b10001;6:glyph_row=5'b01110; endcase
            "H": case(y) 0:glyph_row=5'b10001;1:glyph_row=5'b10001;2:glyph_row=5'b10001;3:glyph_row=5'b11111;4:glyph_row=5'b10001;5:glyph_row=5'b10001;6:glyph_row=5'b10001; endcase
            "O": case(y) 0:glyph_row=5'b01110;1:glyph_row=5'b10001;2:glyph_row=5'b10001;3:glyph_row=5'b10001;4:glyph_row=5'b10001;5:glyph_row=5'b10001;6:glyph_row=5'b01110; endcase
            "V": case(y) 0:glyph_row=5'b10001;1:glyph_row=5'b10001;2:glyph_row=5'b10001;3:glyph_row=5'b10001;4:glyph_row=5'b10001;5:glyph_row=5'b01010;6:glyph_row=5'b00100; endcase
            "G": case(y) 0:glyph_row=5'b01110;1:glyph_row=5'b10001;2:glyph_row=5'b10000;3:glyph_row=5'b10011;4:glyph_row=5'b10001;5:glyph_row=5'b10001;6:glyph_row=5'b01110; endcase
            "/": case(y) 0:glyph_row=5'b00001;1:glyph_row=5'b00010;2:glyph_row=5'b00010;3:glyph_row=5'b00100;4:glyph_row=5'b01000;5:glyph_row=5'b01000;6:glyph_row=5'b10000; endcase
            ".": case(y) 5:glyph_row=5'b00100;6:glyph_row=5'b00100; endcase
            " ": glyph_row=5'b00000;
            default: glyph_row=5'b00000;
        endcase
    end
endfunction

function [7:0] label_char;
    input [3:0] row;
    input [2:0] idx;
    begin
        label_char = " ";
        case (row)
            3'd0: case(idx) 0:label_char="P";1:label_char="M";2:label_char="1";3:label_char=".";4:label_char="0";default:label_char=" "; endcase
            3'd1: case(idx) 0:label_char="P";1:label_char="M";2:label_char="2";3:label_char=".";4:label_char="5";default:label_char=" "; endcase
            3'd2: case(idx) 0:label_char="P";1:label_char="M";2:label_char="1";3:label_char="0";default:label_char=" "; endcase
            3'd3: case(idx) 0:label_char="0";1:label_char=".";2:label_char="3";3:label_char="U";4:label_char="M";default:label_char=" "; endcase
            3'd4: case(idx) 0:label_char="0";1:label_char=".";2:label_char="5";3:label_char="U";4:label_char="M";default:label_char=" "; endcase
            3'd5: case(idx) 0:label_char="1";1:label_char=".";2:label_char="0";3:label_char="U";4:label_char="M";default:label_char=" "; endcase
            3'd6: case(idx) 0:label_char="C";1:label_char="H";2:label_char="2";3:label_char="O";default:label_char=" "; endcase
            3'd7: case(idx) 0:label_char="C";1:label_char="O";2:label_char="2";default:label_char=" "; endcase
            4'd8: case(idx) 0:label_char="V";1:label_char="O";2:label_char="C";default:label_char=" "; endcase
            default: label_char = " ";
        endcase
    end
endfunction

function [7:0] unit_char;
    input [3:0] row;
    input [2:0] idx;
    begin
        unit_char = " ";
        case (row)
            3'd0,3'd1,3'd2: begin
                case(idx)
                    3'd0: unit_char = "U";
                    3'd1: unit_char = "G";
                    3'd2: unit_char = "/";
                    3'd3: unit_char = "M";
                    3'd4: unit_char = "3";
                    default: unit_char = " ";
                endcase
            end
            3'd3,3'd4,3'd5,3'd7: begin
                case(idx)
                    3'd0: unit_char = "P";
                    3'd1: unit_char = "P";
                    3'd2: unit_char = "M";
                    default: unit_char = " ";
                endcase
            end
            3'd6: begin
                case(idx)
                    3'd0: unit_char = "P";
                    3'd1: unit_char = "P";
                    3'd2: unit_char = "B";
                    default: unit_char = " ";
                endcase
            end
            4'd8: begin
                case(idx)
                    3'd0: unit_char = "M";
                    3'd1: unit_char = "G";
                    3'd2: unit_char = "/";
                    3'd3: unit_char = "M";
                    3'd4: unit_char = "3";
                    default: unit_char = " ";
                endcase
            end
            default: unit_char = " ";
        endcase
    end
endfunction

function [15:0] row_value;
    input [3:0] row;
    begin
        case(row)
            3'd0: row_value = v_pm1_cf1;
            3'd1: row_value = v_pm25_cf1;
            3'd2: row_value = v_pm10_cf1;
            3'd3: row_value = v_pcnt_03;
            3'd4: row_value = v_pcnt_05;
            3'd5: row_value = v_pcnt_10;
            3'd6: row_value = v_ch2o;
            3'd7: row_value = v_co2;
            4'd8: row_value = v_voc;
            default: row_value = 16'd0;
        endcase
    end
endfunction

wire in_title = 1'b0;
wire [8:0] tx = pix_x - 9'd32;
wire [8:0] tci_w = tx / CHAR_ADV;
wire [8:0] tcx_w = (tx % CHAR_ADV) / FONT_SCALE;
wire [8:0] tcy_w = (pix_y - TITLE_Y) / FONT_SCALE;
wire [3:0] tci = tci_w[3:0];
wire [3:0] tcx = tcx_w[3:0];
wire [3:0] tcy = tcy_w[3:0];
wire [7:0] tchar = (tci==0)?"A":(tci==1)?"I":(tci==2)?"R":(tci==3)?" ":(tci==4)?"Q":(tci==5)?"U":(tci==6)?"A":(tci==7)?"L":(tci==8)?"I":(tci==9)?"T":(tci==10)?"Y":(tci==11)?" ":(tci==12)?"D":(tci==13)?"A":"T";
wire [4:0] trow_bits = glyph_row(tchar,tcy[2:0]);
wire title_on = 1'b0;

wire [8:0] ly = pix_y - LIST_Y0;
wire [8:0] lrow_w = ly / ROW_STEP;
wire [3:0] lrow = lrow_w[3:0];
wire [8:0] ly_in = ly % ROW_STEP;
wire in_row = (pix_y >= LIST_Y0) && (lrow <= 4'd8) && (ly_in < CHAR_H);

wire in_label = in_row && (pix_x >= LABEL_X) && (pix_x < (LABEL_X + 9'd8*CHAR_ADV));
wire [8:0] lx = pix_x - LABEL_X;
wire [8:0] lci_w = lx / CHAR_ADV;
wire [8:0] lcx_w = (lx % CHAR_ADV) / FONT_SCALE;
wire [8:0] lcy_w = ly_in / FONT_SCALE;
wire [2:0] lci = lci_w[2:0];
wire [3:0] lcx = lcx_w[3:0];
wire [3:0] lcy = lcy_w[3:0];
wire [7:0] lchar = label_char(lrow, lci);
wire [4:0] lrow_bits = glyph_row(lchar,lcy[2:0]);
wire label_on = in_label && (lcx<4'd5) && (lcy<4'd7) && lrow_bits[4'd4 - lcx];

wire in_value = in_row && (pix_x >= VALUE_X) && (pix_x < (VALUE_X + 9'd6*CHAR_ADV));
wire [8:0] vx = pix_x - VALUE_X;
wire [8:0] vci_w = vx / CHAR_ADV;
wire [8:0] vcx_w = (vx % CHAR_ADV) / FONT_SCALE;
wire [8:0] vcy_w = ly_in / FONT_SCALE;
wire [2:0] vci = vci_w[2:0];
wire [3:0] vcx = vcx_w[3:0];
wire [3:0] vcy = vcy_w[3:0];
wire [15:0] rv = row_value(lrow);
wire [3:0] d3 = (rv / 16'd1000) % 10;
wire [3:0] d2 = (rv / 16'd100) % 10;
wire [3:0] d1 = (rv / 16'd10) % 10;
wire [3:0] d0 = rv % 10;
wire [7:0] vchar = (vci==0)?"0"+d3:(vci==1)?"0"+d2:(vci==2)?"0"+d1:(vci==3)?"0"+d0:(vci==4)?" ":" ";
wire [4:0] vrow_bits = glyph_row(vchar,vcy[2:0]);
wire value_on = in_value && (vcx<4'd5) && (vcy<4'd7) && vrow_bits[4'd4 - vcx];

wire in_unit = in_row && (pix_x >= UNIT_X) && (pix_x < (UNIT_X + 9'd6*CHAR_ADV));
wire [8:0] ux = pix_x - UNIT_X;
wire [8:0] uci_w = ux / CHAR_ADV;
wire [8:0] ucx_w = (ux % CHAR_ADV) / FONT_SCALE;
wire [8:0] ucy_w = ly_in / FONT_SCALE;
wire [2:0] uci = uci_w[2:0];
wire [3:0] ucx = ucx_w[3:0];
wire [3:0] ucy = ucy_w[3:0];
wire [7:0] uchar = unit_char(lrow, uci);
wire [4:0] urow_bits = glyph_row(uchar,ucy[2:0]);
wire unit_on = in_unit && (ucx<4'd5) && (ucy<4'd7) && urow_bits[4'd4 - ucx];

wire in_sep = in_row && (pix_x >= 9'd170) && (pix_x < 9'd172);

assign pixel_on = title_on | label_on | value_on | unit_on | in_sep;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        state <= ST_RST_LOW; next_state <= ST_SPI_INIT; delay_cnt <= 27'd0; seq_idx <= 4'd0;
        pix_left <= 18'd0; pix_x <= 9'd0; pix_y <= 9'd0;
        drv_en <= 1'b0; drv_type <= CMD_ONLY; drv_cmd <= 8'h00; drv_param <= 8'h00;
        lcd_rst_n <= 1'b0; sensor_update_ack <= 1'b0;
        v_pm1_cf1<=0;v_pm25_cf1<=0;v_pm10_cf1<=0;v_pcnt_03<=0;v_pcnt_05<=0;v_pcnt_10<=0;v_ch2o<=0;v_co2<=0;v_voc<=0;
    end else begin
        drv_en <= 1'b0; sensor_update_ack <= 1'b0;
        if (delay_cnt != 0) delay_cnt <= delay_cnt - 1'b1;
        else begin
            case (state)
                ST_RST_LOW: begin lcd_rst_n<=1'b0; delay_cnt<=DLY_RST_LOW; next_state<=ST_RST_HI; state<=ST_DELAY; end
                ST_RST_HI: begin lcd_rst_n<=1'b1; delay_cnt<=DLY_RST_HI; next_state<=ST_SPI_INIT; state<=ST_DELAY; end
                ST_SPI_INIT: begin drv_type<=INIT_CTRL; drv_en<=1'b1; delay_cnt<=DLY_20MS; next_state<=ST_SWRESET; state<=ST_DELAY; end
                ST_SWRESET: begin drv_type<=CMD_ONLY; drv_cmd<=8'h01; drv_en<=1'b1; delay_cnt<=DLY_120MS; next_state<=ST_SLPOUT; state<=ST_DELAY; end
                ST_SLPOUT: begin drv_type<=CMD_ONLY; drv_cmd<=8'h11; drv_en<=1'b1; delay_cnt<=DLY_120MS; next_state<=ST_COLMOD; state<=ST_DELAY; end
                ST_COLMOD: begin drv_type<=CMD_PARAM; drv_cmd<=8'h3A; drv_param<=8'h66; drv_en<=1'b1; delay_cnt<=TX_GAP_CYC; next_state<=ST_MADCTL; state<=ST_DELAY; end
                ST_MADCTL: begin drv_type<=CMD_PARAM; drv_cmd<=8'h36; drv_param<=8'h28; drv_en<=1'b1; delay_cnt<=TX_GAP_CYC; next_state<=ST_NORON; state<=ST_DELAY; end
                ST_NORON: begin drv_type<=CMD_ONLY; drv_cmd<=8'h13; drv_en<=1'b1; delay_cnt<=TX_GAP_CYC; next_state<=ST_DISPON; state<=ST_DELAY; end
                ST_DISPON: begin drv_type<=CMD_ONLY; drv_cmd<=8'h29; drv_en<=1'b1; delay_cnt<=DLY_20MS; seq_idx<=0; next_state<=ST_CASET; state<=ST_DELAY; end
                ST_CASET: begin
                    case(seq_idx)
                        0: begin drv_type<=CMD_ONLY; drv_cmd<=8'h2A; end
                        1: begin drv_type<=DATA_ONLY; drv_cmd<=8'h00; end
                        2: begin drv_type<=DATA_ONLY; drv_cmd<=8'h00; end
                        3: begin drv_type<=DATA_ONLY; drv_cmd<=8'h01; end
                        default: begin drv_type<=DATA_ONLY; drv_cmd<=8'hDF; end
                    endcase
                    drv_en<=1'b1; delay_cnt<=TX_GAP_CYC; state<=ST_DELAY;
                    if (seq_idx==4'd4) begin seq_idx<=4'd0; next_state<=ST_PASET; end else begin seq_idx<=seq_idx+4'd1; next_state<=ST_CASET; end
                end
                ST_PASET: begin
                    case(seq_idx)
                        0: begin drv_type<=CMD_ONLY; drv_cmd<=8'h2B; end
                        1: begin drv_type<=DATA_ONLY; drv_cmd<=8'h00; end
                        2: begin drv_type<=DATA_ONLY; drv_cmd<=8'h00; end
                        3: begin drv_type<=DATA_ONLY; drv_cmd<=8'h01; end
                        default: begin drv_type<=DATA_ONLY; drv_cmd<=8'h3F; end
                    endcase
                    drv_en<=1'b1; delay_cnt<=TX_GAP_CYC; state<=ST_DELAY;
                    if (seq_idx==4'd4) begin seq_idx<=4'd0; next_state<=ST_RAMWR; end else begin seq_idx<=seq_idx+4'd1; next_state<=ST_PASET; end
                end
                ST_RAMWR: begin
                    drv_type<=CMD_ONLY; drv_cmd<=8'h2C; drv_en<=1'b1;
                    v_pm1_cf1<=pm1_cf1; v_pm25_cf1<=pm25_cf1; v_pm10_cf1<=pm10_cf1;
                    v_pcnt_03<=pcnt_03; v_pcnt_05<=pcnt_05; v_pcnt_10<=pcnt_10;
                    v_ch2o<=ch2o;
                    v_co2<=co2;
                    v_voc<=voc;
                    pix_left<=LCD_W*LCD_H; pix_x<=9'd0; pix_y<=9'd0;
                    delay_cnt<=TX_GAP_CYC; next_state<=ST_PIX_HI; state<=ST_DELAY;
                end
                ST_PIX_HI: begin drv_type<=DATA_ONLY; drv_cmd<=pix_r; drv_en<=1'b1; delay_cnt<=TX_GAP_CYC; next_state<=ST_PIX_MID; state<=ST_DELAY; end
                ST_PIX_MID: begin drv_type<=DATA_ONLY; drv_cmd<=pix_g; drv_en<=1'b1; delay_cnt<=TX_GAP_CYC; next_state<=ST_PIX_LO; state<=ST_DELAY; end
                ST_PIX_LO: begin
                    drv_type<=DATA_ONLY; drv_cmd<=pix_b; drv_en<=1'b1; delay_cnt<=TX_GAP_CYC; state<=ST_DELAY;
                    if (pix_left==1) next_state<=ST_HOLD;
                    else begin
                        pix_left<=pix_left-1;
                        if (pix_x==LCD_WM1) begin pix_x<=9'd0; if (pix_y==LCD_HM1) pix_y<=9'd0; else pix_y<=pix_y+9'd1; end
                        else pix_x<=pix_x+9'd1;
                        next_state<=ST_PIX_HI;
                    end
                end
                ST_HOLD: begin
                    if (sensor_update) begin sensor_update_ack<=1'b1; seq_idx<=0; delay_cnt<=TX_GAP_CYC; next_state<=ST_CASET; state<=ST_DELAY; end
                    else state<=ST_HOLD;
                end
                ST_DELAY: if (!drv_busy) state <= next_state;
                default: state <= ST_RST_LOW;
            endcase
        end
    end
end

spi_driver u_spi_driver (
    .sys_clk(sys_clk), .sys_rst_n(sys_rst_n), .en(drv_en), .command_type(drv_type), .command(drv_cmd), .param(drv_param),
    .dcx(dcx), .spi_sclk(spi_sclk), .spi_mosi(spi_mosi), .spi_cs_n(spi_cs_n), .busy(drv_busy), .done(drv_done)
);

endmodule
