module ssd1309_driver (
    input sys_clk,
    input sys_rst_n,
    input refresh_req,
    input [15:0] standard_pm1_0,
    input [15:0] standard_pm2_5,
    input [15:0] standard_pm10,
    input [15:0] pm0_3,
    input [15:0] pm0_5,
    input [15:0] pm1_0,
    input [15:0] ch2o_data,

    output init_done,
    output reg refresh_done,
    inout SCL,
    inout SDA
);

parameter AUTO_REFRESH = 1'b0;
parameter TEST_PATTERN = 1'b0;
parameter VALUE_COL_START = 8'd56;
parameter VALUE_COL_END   = 8'd95;
parameter ROW0_PAGE      = 8'd0;
parameter ROW0_COL_START = 8'd0;
parameter ROW0_COL_END   = 8'd127;
parameter ROW1_PAGE      = 8'd1;
parameter ROW1_COL_START = 8'd0;
parameter ROW1_COL_END   = 8'd127;
parameter ROW2_PAGE      = 8'd2;
parameter ROW2_COL_START = 8'd0;
parameter ROW2_COL_END   = 8'd127;
parameter ROW3_PAGE      = 8'd3;
parameter ROW3_COL_START = 8'd0;
parameter ROW3_COL_END   = 8'd127;
parameter ROW4_PAGE      = 8'd4;
parameter ROW4_COL_START = 8'd0;
parameter ROW4_COL_END   = 8'd127;
parameter ROW5_PAGE      = 8'd5;
parameter ROW5_COL_START = 8'd0;
parameter ROW5_COL_END   = 8'd127;
parameter ROW6_PAGE      = 8'd6;
parameter ROW6_COL_START = 8'd0;
parameter ROW6_COL_END   = 8'd127;
parameter ROW7_PAGE      = 8'd7;
parameter ROW7_COL_START = 8'd0;
parameter ROW7_COL_END   = 8'd127;
parameter ROW0_ITEM      = 4'd0;
parameter ROW1_ITEM      = 4'd1;
parameter ROW2_ITEM      = 4'd2;
parameter ROW3_ITEM      = 4'd3;
parameter ROW4_ITEM      = 4'd4;
parameter ROW5_ITEM      = 4'd5;
parameter ROW6_ITEM      = 4'd6;
parameter ROW7_ITEM      = 4'd7;

localparam REFRESH_DELAY = 24'd5_000_000;
localparam ROW_LAST = 3'd6;

localparam [4:0]
    IDLE              = 5'd0,
    I2C_INIT          = 5'd1,
    INIT_SEND         = 5'd2,
    CLEAR_COLUMN_ADDR = 5'd3,
    CLEAR_PAGE_ADDR   = 5'd4,
    CLEAR_SCREEN      = 5'd5,
    SET_COLUMN_ADDR   = 5'd6,
    SET_PAGE_ADDR     = 5'd7,
    WRITE_CHAR        = 5'd8,
    WAIT_REFRESH      = 5'd9,
    FIND_DIRTY_CHAR   = 5'd10,
    RESTORE_LABEL_CHAR= 5'd11;

localparam [7:0]
    CHAR_SPACE = 8'h20,
    CHAR_DOT   = 8'h2e,
    CHAR_COLON = 8'h3a,
    CHAR_0     = 8'h30,
    CHAR_1     = 8'h31,
    CHAR_2     = 8'h32,
    CHAR_3     = 8'h33,
    CHAR_5     = 8'h35,
    CHAR_A     = 8'h41,
    CHAR_C     = 8'h43,
    CHAR_F     = 8'h46,
    CHAR_H     = 8'h48,
    CHAR_M     = 8'h4d,
    CHAR_O     = 8'h4f,
    CHAR_P     = 8'h50,
    CHAR_R     = 8'h52,
    CHAR_S     = 8'h53,
    CHAR_U     = 8'h55,
    CHAR_V     = 8'h56;

reg en;
reg init;
reg command_data;
wire i2c_done;
wire i2c_busy;
reg [7:0] payload_len;
reg [63:0] data;
wire [7:0] active_write_col;
wire [7:0] active_write_col_end;
wire can_start_i2c;
wire xfer_done;
wire [4:0] dirty_char_index;
wire [7:0] dirty_display_char;
wire [7:0] dirty_shown_char;
wire dirty_char_changed;
wire dirty_scan_last;

reg ssd1309_init_done;
reg [4:0] cur_state;
reg [4:0] next_state;
reg [4:0] init_index;
reg [7:0] clear_index;
reg [2:0] row_index;
reg [4:0] char_index;
reg [7:0] col_index;
reg value_only_refresh;
reg refresh_pending;
reg xfer_started;
reg label_restore_active;
reg [2:0] label_restore_row;
reg [2:0] label_restore_char;
reg [1:0] dirty_digit;
reg [23:0] refresh_cnt;

reg [15:0] pm1_0_value;
reg [15:0] pm2_5_value;
reg [15:0] pm10_value;
reg [15:0] p_0_3_value;
reg [15:0] p_0_5_value;
reg [15:0] p_1_0_value;
reg [15:0] p_2_5_value;
reg [15:0] p_5_0_value;
reg [15:0] p_10_value;
reg [15:0] reserve0_value;
reg [15:0] reserve1_value;
reg [15:0] reserve2_value;
reg [15:0] pending_pm1_0_value;
reg [15:0] pending_pm2_5_value;
reg [15:0] pending_pm10_value;
reg [15:0] pending_p_0_3_value;
reg [15:0] pending_p_0_5_value;
reg [15:0] pending_p_1_0_value;
reg [15:0] pending_ch2o_value;
reg [7:0] shown_r0_d0;
reg [7:0] shown_r0_d1;
reg [7:0] shown_r0_d2;
reg [7:0] shown_r0_d3;
reg [7:0] shown_r1_d0;
reg [7:0] shown_r1_d1;
reg [7:0] shown_r1_d2;
reg [7:0] shown_r1_d3;
reg [7:0] shown_r2_d0;
reg [7:0] shown_r2_d1;
reg [7:0] shown_r2_d2;
reg [7:0] shown_r2_d3;
reg [7:0] shown_r3_d0;
reg [7:0] shown_r3_d1;
reg [7:0] shown_r3_d2;
reg [7:0] shown_r3_d3;
reg [7:0] shown_r4_d0;
reg [7:0] shown_r4_d1;
reg [7:0] shown_r4_d2;
reg [7:0] shown_r4_d3;
reg [7:0] shown_r5_d0;
reg [7:0] shown_r5_d1;
reg [7:0] shown_r5_d2;
reg [7:0] shown_r5_d3;
reg [7:0] shown_r6_d0;
reg [7:0] shown_r6_d1;
reg [7:0] shown_r6_d2;
reg [7:0] shown_r6_d3;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        pending_pm1_0_value <= 16'd0;
        pending_pm2_5_value <= 16'd0;
        pending_pm10_value <= 16'd0;
        pending_p_0_3_value <= 16'd0;
        pending_p_0_5_value <= 16'd0;
        pending_p_1_0_value <= 16'd0;
        pending_ch2o_value <= 16'd0;
    end
    else begin
        if (refresh_req) begin
            pending_pm1_0_value <= standard_pm1_0;
            pending_pm2_5_value <= standard_pm2_5;
            pending_pm10_value <= standard_pm10;
            pending_p_0_3_value <= pm0_3;
            pending_p_0_5_value <= pm0_5;
            pending_p_1_0_value <= pm1_0;
            pending_ch2o_value <= ch2o_data;
        end
    end
end

function [7:0] init_payload_len;
    input [4:0] index;
    begin
        case (index)
            5'd0:  init_payload_len = 8'd2;
            5'd1:  init_payload_len = 8'd1;
            5'd2:  init_payload_len = 8'd1;
            5'd3:  init_payload_len = 8'd2;
            5'd4:  init_payload_len = 8'd2;
            5'd5:  init_payload_len = 8'd2;
            5'd6:  init_payload_len = 8'd1;
            5'd7:  init_payload_len = 8'd1;
            5'd8:  init_payload_len = 8'd1;
            5'd9:  init_payload_len = 8'd2;
            5'd10: init_payload_len = 8'd2;
            5'd11: init_payload_len = 8'd2;
            5'd12: init_payload_len = 8'd1;
            5'd13: init_payload_len = 8'd1;
            5'd14: init_payload_len = 8'd2;
            5'd15: init_payload_len = 8'd2;
            5'd16: init_payload_len = 8'd1;
            5'd17: init_payload_len = 8'd1;
            5'd18: init_payload_len = 8'd2;
            5'd19: init_payload_len = 8'd1;
            default:init_payload_len = 8'd0;
        endcase
    end
endfunction

function [63:0] init_payload_data;
    input [4:0] index;
    begin
        case (index)
            5'd0:  init_payload_data = {8'hfd, 8'h12};
            5'd1:  init_payload_data = 8'hae;
            5'd2:  init_payload_data = 8'h2e;
            5'd3:  init_payload_data = {8'hd5, 8'h80};
            5'd4:  init_payload_data = {8'ha8, 8'h3f};
            5'd5:  init_payload_data = {8'hd3, 8'h00};
            5'd6:  init_payload_data = 8'h40;
            5'd7:  init_payload_data = 8'ha1;
            5'd8:  init_payload_data = 8'hc8;
            5'd9:  init_payload_data = {8'hda, 8'h12};
            5'd10: init_payload_data = {8'h81, 8'h7f};
            5'd11: init_payload_data = 8'ha4;
            5'd12: init_payload_data = 8'ha6;
            5'd13: init_payload_data = {8'hd9, 8'h22};
            5'd14: init_payload_data = {8'hdb, 8'h34};
            5'd15: init_payload_data = {8'h20, 8'h00};
            5'd16: init_payload_data = 8'h2e;
            5'd17: init_payload_data = 8'h40;
            5'd18: init_payload_data = {8'hd3, 8'h00};
            5'd19: init_payload_data = 8'haf;
            default:init_payload_data = 64'd0;
        endcase
    end
endfunction

function [7:0] row_page;
    input [2:0] row;
    begin
        case (row)
            3'd0: row_page = ROW0_PAGE;
            3'd1: row_page = ROW1_PAGE;
            3'd2: row_page = ROW2_PAGE;
            3'd3: row_page = ROW3_PAGE;
            3'd4: row_page = ROW4_PAGE;
            3'd5: row_page = ROW5_PAGE;
            3'd6: row_page = ROW6_PAGE;
            default: row_page = ROW7_PAGE;
        endcase
    end
endfunction

function [7:0] row_col_start;
    input [2:0] row;
    begin
        case (row)
            3'd0: row_col_start = ROW0_COL_START;
            3'd1: row_col_start = ROW1_COL_START;
            3'd2: row_col_start = ROW2_COL_START;
            3'd3: row_col_start = ROW3_COL_START;
            3'd4: row_col_start = ROW4_COL_START;
            3'd5: row_col_start = ROW5_COL_START;
            3'd6: row_col_start = ROW6_COL_START;
            default: row_col_start = ROW7_COL_START;
        endcase
    end
endfunction

function [7:0] row_col_end;
    input [2:0] row;
    begin
        case (row)
            3'd0: row_col_end = ROW0_COL_END;
            3'd1: row_col_end = ROW1_COL_END;
            3'd2: row_col_end = ROW2_COL_END;
            3'd3: row_col_end = ROW3_COL_END;
            3'd4: row_col_end = ROW4_COL_END;
            3'd5: row_col_end = ROW5_COL_END;
            3'd6: row_col_end = ROW6_COL_END;
            default: row_col_end = ROW7_COL_END;
        endcase
    end
endfunction

function [7:0] active_col_start;
    input value_only;
    input [2:0] row;
    begin
        active_col_start = (value_only) ? {char_index, 3'b000} : row_col_start(row);
    end
endfunction

function [7:0] active_col_end;
    input value_only;
    input [2:0] row;
    begin
        active_col_end = (value_only) ? ({char_index, 3'b000} + 8'd7) : row_col_end(row);
    end
endfunction

assign active_write_col = active_col_start(value_only_refresh, row_index) + col_index;
assign active_write_col_end = active_write_col + 8'd7;
assign can_start_i2c = !i2c_busy && !i2c_done && !xfer_started;
assign xfer_done = xfer_started && i2c_done;
assign dirty_char_index = 5'd8 + {3'b000, dirty_digit};
assign dirty_display_char = display_char(row_index, dirty_char_index);
assign dirty_shown_char = shown_value_char(row_index, dirty_digit);
assign dirty_char_changed = (dirty_display_char != dirty_shown_char);
assign dirty_scan_last = (row_index == ROW_LAST) && (dirty_digit == 2'd3);

function [3:0] display_item;
    input [2:0] row;
    begin
        case (row)
            3'd0: display_item = ROW0_ITEM;
            3'd1: display_item = ROW1_ITEM;
            3'd2: display_item = ROW2_ITEM;
            3'd3: display_item = ROW3_ITEM;
            3'd4: display_item = ROW4_ITEM;
            3'd5: display_item = ROW5_ITEM;
            3'd6: display_item = ROW6_ITEM;
            default: display_item = ROW7_ITEM;
        endcase
    end
endfunction

function [19:0] bin16_to_bcd;
    input [15:0] bin;
    integer i;
    reg [35:0] shift;
    begin
        shift = 36'd0;
        shift[15:0] = bin;
        for (i = 0; i < 16; i = i + 1) begin
            if (shift[19:16] >= 4'd5) shift[19:16] = shift[19:16] + 4'd3;
            if (shift[23:20] >= 4'd5) shift[23:20] = shift[23:20] + 4'd3;
            if (shift[27:24] >= 4'd5) shift[27:24] = shift[27:24] + 4'd3;
            if (shift[31:28] >= 4'd5) shift[31:28] = shift[31:28] + 4'd3;
            if (shift[35:32] >= 4'd5) shift[35:32] = shift[35:32] + 4'd3;
            shift = shift << 1;
        end
        bin16_to_bcd = shift[35:16];
    end
endfunction

function [3:0] dec_digit;
    input [15:0] value;
    input [2:0] digit_pos;
    reg [19:0] bcd;
    begin
        bcd = bin16_to_bcd(value);
        case (digit_pos)
            3'd4: dec_digit = bcd[19:16];
            3'd3: dec_digit = bcd[15:12];
            3'd2: dec_digit = bcd[11:8];
            3'd1: dec_digit = bcd[7:4];
            default: dec_digit = bcd[3:0];
        endcase
    end
endfunction

function [7:0] digit_char;
    input [15:0] value;
    input [2:0] digit_pos;
    begin
        digit_char = CHAR_0 + dec_digit(value, digit_pos);
    end
endfunction

function [15:0] item_value;
    input [3:0] item;
    begin
        case (item)
            4'd0: item_value = pm1_0_value;
            4'd1: item_value = pm2_5_value;
            4'd2: item_value = pm10_value;
            4'd3: item_value = p_0_3_value;
            4'd4: item_value = p_0_5_value;
            4'd5: item_value = p_1_0_value;
            4'd6: item_value = p_2_5_value;
            4'd7: item_value = p_5_0_value;
            4'd8: item_value = p_10_value;
            4'd9: item_value = reserve0_value;
            4'd10:item_value = reserve1_value;
            4'd11:item_value = reserve2_value;
            default:item_value = 16'd0;
        endcase
    end
endfunction

function [15:0] display_value;
    input [15:0] value;
    begin
        display_value = (value > 16'd9999) ? 16'd9999 : value;
    end
endfunction

function [7:0] label_char;
    input [3:0] item;
    input [2:0] index;
    begin
        label_char = CHAR_SPACE;
        case (item)
            4'd0: begin
                case (index)
                    3'd0: label_char = CHAR_P;
                    3'd1: label_char = CHAR_M;
                    3'd2: label_char = CHAR_1;
                    3'd3: label_char = CHAR_DOT;
                    3'd4: label_char = CHAR_0;
                    3'd5: label_char = CHAR_SPACE;
                    default: label_char = CHAR_SPACE;
                endcase
            end
            4'd1: begin
                case (index)
                    3'd0: label_char = CHAR_P;
                    3'd1: label_char = CHAR_M;
                    3'd2: label_char = CHAR_2;
                    3'd3: label_char = CHAR_DOT;
                    3'd4: label_char = CHAR_5;
                    3'd5: label_char = CHAR_SPACE;
                    default: label_char = CHAR_SPACE;
                endcase
            end
            4'd2: begin
                case (index)
                    3'd0: label_char = CHAR_P;
                    3'd1: label_char = CHAR_M;
                    3'd2: label_char = CHAR_1;
                    3'd3: label_char = CHAR_0;
                    3'd4: label_char = CHAR_SPACE;
                    3'd5: label_char = CHAR_SPACE;
                    default: label_char = CHAR_SPACE;
                endcase
            end
            4'd3: begin
                case (index)
                    3'd0: label_char = CHAR_0;
                    3'd1: label_char = CHAR_DOT;
                    3'd2: label_char = CHAR_3;
                    3'd3: label_char = CHAR_U;
                    3'd4: label_char = CHAR_M;
                    3'd5: label_char = CHAR_SPACE;
                    default: label_char = CHAR_SPACE;
                endcase
            end
            4'd4: begin
                case (index)
                    3'd0: label_char = CHAR_0;
                    3'd1: label_char = CHAR_DOT;
                    3'd2: label_char = CHAR_5;
                    3'd3: label_char = CHAR_U;
                    3'd4: label_char = CHAR_M;
                    3'd5: label_char = CHAR_SPACE;
                    default: label_char = CHAR_SPACE;
                endcase
            end
            4'd5: begin
                case (index)
                    3'd0: label_char = CHAR_1;
                    3'd1: label_char = CHAR_DOT;
                    3'd2: label_char = CHAR_0;
                    3'd3: label_char = CHAR_U;
                    3'd4: label_char = CHAR_M;
                    3'd5: label_char = CHAR_SPACE;
                    default: label_char = CHAR_SPACE;
                endcase
            end
            4'd6: begin
                case (index)
                    3'd0: label_char = CHAR_P;
                    3'd1: label_char = CHAR_2;
                    3'd2: label_char = CHAR_5;
                    default: label_char = CHAR_SPACE;
                endcase
            end
            4'd7: begin
                case (index)
                    3'd0: label_char = CHAR_P;
                    3'd1: label_char = CHAR_5;
                    3'd2: label_char = CHAR_0;
                    default: label_char = CHAR_SPACE;
                endcase
            end
            4'd8: begin
                case (index)
                    3'd0: label_char = CHAR_P;
                    3'd1: label_char = CHAR_1;
                    3'd2: label_char = CHAR_0;
                    3'd3: label_char = CHAR_0;
                    default: label_char = CHAR_SPACE;
                endcase
            end
            4'd9: begin
                case (index)
                    3'd0: label_char = CHAR_C;
                    3'd1: label_char = CHAR_H;
                    3'd2: label_char = CHAR_2;
                    3'd3: label_char = CHAR_O;
                    3'd4: label_char = CHAR_SPACE;
                    3'd5: label_char = CHAR_SPACE;
                    default: label_char = CHAR_SPACE;
                endcase
            end
            default: begin
                case (index)
                    3'd0: label_char = CHAR_R;
                    3'd1: label_char = CHAR_S;
                    3'd2: label_char = CHAR_V;
                    default: label_char = CHAR_SPACE;
                endcase
            end
        endcase
    end
endfunction

function [7:0] display_char;
    input [2:0] row;
    input [4:0] index;
    reg [3:0] item;
    reg [15:0] value;
    begin
        item = display_item(row);
        value = display_value(item_value(item));
        display_char = CHAR_SPACE;
        case (index)
            5'd0: display_char = label_char(item, 3'd0);
            5'd1: display_char = label_char(item, 3'd1);
            5'd2: display_char = label_char(item, 3'd2);
            5'd3: display_char = label_char(item, 3'd3);
            5'd4: display_char = label_char(item, 3'd4);
            5'd5: display_char = label_char(item, 3'd5);
            5'd6: display_char = CHAR_COLON;
            5'd7: display_char = CHAR_SPACE;
            5'd8: display_char = digit_char(value, 3'd3);
            5'd9: display_char = digit_char(value, 3'd2);
            5'd10:display_char = digit_char(value, 3'd1);
            5'd11:display_char = digit_char(value, 3'd0);
            default: display_char = CHAR_SPACE;
        endcase
    end
endfunction

function [7:0] shown_value_char;
    input [2:0] row;
    input [1:0] digit;
    begin
        shown_value_char = CHAR_0;
        case (row)
            3'd0: begin
                case (digit)
                    2'd0: shown_value_char = shown_r0_d0;
                    2'd1: shown_value_char = shown_r0_d1;
                    2'd2: shown_value_char = shown_r0_d2;
                    default: shown_value_char = shown_r0_d3;
                endcase
            end
            3'd1: begin
                case (digit)
                    2'd0: shown_value_char = shown_r1_d0;
                    2'd1: shown_value_char = shown_r1_d1;
                    2'd2: shown_value_char = shown_r1_d2;
                    default: shown_value_char = shown_r1_d3;
                endcase
            end
            3'd2: begin
                case (digit)
                    2'd0: shown_value_char = shown_r2_d0;
                    2'd1: shown_value_char = shown_r2_d1;
                    2'd2: shown_value_char = shown_r2_d2;
                    default: shown_value_char = shown_r2_d3;
                endcase
            end
            3'd3: begin
                case (digit)
                    2'd0: shown_value_char = shown_r3_d0;
                    2'd1: shown_value_char = shown_r3_d1;
                    2'd2: shown_value_char = shown_r3_d2;
                    default: shown_value_char = shown_r3_d3;
                endcase
            end
            3'd4: begin
                case (digit)
                    2'd0: shown_value_char = shown_r4_d0;
                    2'd1: shown_value_char = shown_r4_d1;
                    2'd2: shown_value_char = shown_r4_d2;
                    default: shown_value_char = shown_r4_d3;
                endcase
            end
            3'd5: begin
                case (digit)
                    2'd0: shown_value_char = shown_r5_d0;
                    2'd1: shown_value_char = shown_r5_d1;
                    2'd2: shown_value_char = shown_r5_d2;
                    default: shown_value_char = shown_r5_d3;
                endcase
            end
            default: begin
                case (digit)
                    2'd0: shown_value_char = shown_r6_d0;
                    2'd1: shown_value_char = shown_r6_d1;
                    2'd2: shown_value_char = shown_r6_d2;
                    default: shown_value_char = shown_r6_d3;
                endcase
            end
        endcase
    end
endfunction

function [63:0] char_bitmap;
    input [7:0] ascii;
    begin
        case (ascii)
            CHAR_0:     char_bitmap = {8'h3e, 8'h51, 8'h49, 8'h45, 8'h3e, 8'h00, 8'h00, 8'h00};
            CHAR_1:     char_bitmap = {8'h00, 8'h42, 8'h7f, 8'h40, 8'h00, 8'h00, 8'h00, 8'h00};
            8'h32:      char_bitmap = {8'h62, 8'h51, 8'h49, 8'h49, 8'h46, 8'h00, 8'h00, 8'h00};
            8'h33:      char_bitmap = {8'h22, 8'h49, 8'h49, 8'h49, 8'h36, 8'h00, 8'h00, 8'h00};
            8'h34:      char_bitmap = {8'h18, 8'h14, 8'h12, 8'h7f, 8'h10, 8'h00, 8'h00, 8'h00};
            8'h35:      char_bitmap = {8'h2f, 8'h49, 8'h49, 8'h49, 8'h31, 8'h00, 8'h00, 8'h00};
            8'h36:      char_bitmap = {8'h3e, 8'h49, 8'h49, 8'h49, 8'h32, 8'h00, 8'h00, 8'h00};
            8'h37:      char_bitmap = {8'h01, 8'h71, 8'h09, 8'h05, 8'h03, 8'h00, 8'h00, 8'h00};
            8'h38:      char_bitmap = {8'h36, 8'h49, 8'h49, 8'h49, 8'h36, 8'h00, 8'h00, 8'h00};
            8'h39:      char_bitmap = {8'h26, 8'h49, 8'h49, 8'h49, 8'h3e, 8'h00, 8'h00, 8'h00};
            CHAR_DOT:   char_bitmap = {8'h60, 8'h60, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00};
            CHAR_COLON: char_bitmap = {8'h00, 8'h00, 8'h36, 8'h36, 8'h00, 8'h00, 8'h00, 8'h00};
            CHAR_A:     char_bitmap = {8'h00, 8'h7e, 8'h11, 8'h11, 8'h11, 8'h7e, 8'h00, 8'h00};
            CHAR_C:     char_bitmap = {8'h00, 8'h3e, 8'h41, 8'h41, 8'h41, 8'h22, 8'h00, 8'h00};
            CHAR_F:     char_bitmap = {8'h00, 8'h7f, 8'h09, 8'h09, 8'h09, 8'h01, 8'h00, 8'h00};
            CHAR_H:     char_bitmap = {8'h00, 8'h7f, 8'h08, 8'h08, 8'h08, 8'h7f, 8'h00, 8'h00};
            CHAR_M:     char_bitmap = {8'h7f, 8'h02, 8'h0c, 8'h02, 8'h7f, 8'h00, 8'h00, 8'h00};
            CHAR_O:     char_bitmap = {8'h00, 8'h3e, 8'h41, 8'h41, 8'h41, 8'h3e, 8'h00, 8'h00};
            CHAR_P:     char_bitmap = {8'h7f, 8'h09, 8'h09, 8'h09, 8'h06, 8'h00, 8'h00, 8'h00};
            CHAR_R:     char_bitmap = {8'h00, 8'h7f, 8'h09, 8'h19, 8'h29, 8'h46, 8'h00, 8'h00};
            CHAR_U:     char_bitmap = {8'h3f, 8'h40, 8'h40, 8'h40, 8'h3f, 8'h00, 8'h00, 8'h00};
            CHAR_S:     char_bitmap = {8'h00, 8'h26, 8'h49, 8'h49, 8'h49, 8'h32, 8'h00, 8'h00};
            CHAR_V:     char_bitmap = {8'h00, 8'h1f, 8'h20, 8'h40, 8'h20, 8'h1f, 8'h00, 8'h00};
            default:    char_bitmap = 64'd0;
        endcase
    end
endfunction

function [7:0] bitmap_col;
    input [63:0] bitmap;
    input [2:0] col;
    begin
        case (col)
            3'd0: bitmap_col = bitmap[63:56];
            3'd1: bitmap_col = bitmap[55:48];
            3'd2: bitmap_col = bitmap[47:40];
            3'd3: bitmap_col = bitmap[39:32];
            3'd4: bitmap_col = bitmap[31:24];
            3'd5: bitmap_col = bitmap[23:16];
            3'd6: bitmap_col = bitmap[15:8];
            default: bitmap_col = bitmap[7:0];
        endcase
    end
endfunction

function [7:0] test_pattern_col;
    input [2:0] row;
    input [7:0] col;
    begin
        if (col < 8'd4)
            test_pattern_col = 8'hff;
        else if (col < 8'd8)
            test_pattern_col = 8'h00;
        else if (col[4:0] == 5'd0)
            test_pattern_col = 8'hff;
        else if (col[4:0] == 5'd1)
            test_pattern_col = 8'h81;
        else if (col[4:0] == 5'd2)
            test_pattern_col = 8'h81;
        else if (col[4:0] == 5'd3)
            test_pattern_col = 8'hff;
        else if (col[3:0] == row)
            test_pattern_col = 8'h18;
        else
            test_pattern_col = 8'h00;
    end
endfunction

assign init_done = ssd1309_init_done;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) cur_state <= IDLE;
    else cur_state <= next_state;
end

always @(*) begin
    case (cur_state)
        IDLE:              next_state = I2C_INIT;
        I2C_INIT:          next_state = (xfer_done) ? INIT_SEND : I2C_INIT;
        INIT_SEND:         next_state = (xfer_done && init_index == 5'd19) ? CLEAR_COLUMN_ADDR : INIT_SEND;
        CLEAR_COLUMN_ADDR: next_state = (xfer_done) ? CLEAR_PAGE_ADDR : CLEAR_COLUMN_ADDR;
        CLEAR_PAGE_ADDR:   next_state = (xfer_done) ? CLEAR_SCREEN : CLEAR_PAGE_ADDR;
        CLEAR_SCREEN:      next_state = (xfer_done && clear_index == 8'd127) ? SET_COLUMN_ADDR : CLEAR_SCREEN;
        SET_COLUMN_ADDR:   next_state = (xfer_done) ? SET_PAGE_ADDR : SET_COLUMN_ADDR;
        SET_PAGE_ADDR:     next_state = (xfer_done) ? WRITE_CHAR : SET_PAGE_ADDR;
        WRITE_CHAR:        next_state = (xfer_done) ? ((label_restore_active) ? WAIT_REFRESH : ((value_only_refresh) ? FIND_DIRTY_CHAR : ((active_write_col_end >= active_col_end(value_only_refresh, row_index)) ? ((row_index == ROW_LAST) ? WAIT_REFRESH : SET_COLUMN_ADDR) : WRITE_CHAR))) : WRITE_CHAR;
        WAIT_REFRESH:      next_state = (refresh_pending || (AUTO_REFRESH && refresh_cnt == REFRESH_DELAY)) ? FIND_DIRTY_CHAR : WAIT_REFRESH;
        FIND_DIRTY_CHAR:   next_state = (dirty_char_changed) ? SET_COLUMN_ADDR : ((dirty_scan_last) ? WAIT_REFRESH : FIND_DIRTY_CHAR);
        RESTORE_LABEL_CHAR:next_state = SET_COLUMN_ADDR;
        default:           next_state = IDLE;
    endcase
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        en <= 1'b0;
        init <= 1'b0;
        command_data <= 1'b0;
        payload_len <= 8'd0;
        data <= 64'd0;
        ssd1309_init_done <= 1'b0;
        refresh_done <= 1'b0;
        init_index <= 5'd0;
        clear_index <= 8'd0;
        row_index <= 3'd0;
        char_index <= 5'd0;
        col_index <= 8'd0;
        value_only_refresh <= 1'b0;
        refresh_pending <= 1'b0;
        xfer_started <= 1'b0;
        label_restore_active <= 1'b0;
        label_restore_row <= 3'd0;
        label_restore_char <= 3'd0;
        dirty_digit <= 2'd0;
        refresh_cnt <= 24'd0;
        pm1_0_value <= 16'd0;
        pm2_5_value <= 16'd0;
        pm10_value <= 16'd0;
        p_0_3_value <= 16'd0;
        p_0_5_value <= 16'd0;
        p_1_0_value <= 16'd0;
        p_2_5_value <= 16'd0;
        p_5_0_value <= 16'd0;
        p_10_value <= 16'd0;
        reserve0_value <= 16'd0;
        reserve1_value <= 16'd0;
        reserve2_value <= 16'd0;
        shown_r0_d0 <= CHAR_0;
        shown_r0_d1 <= CHAR_0;
        shown_r0_d2 <= CHAR_0;
        shown_r0_d3 <= CHAR_0;
        shown_r1_d0 <= CHAR_0;
        shown_r1_d1 <= CHAR_0;
        shown_r1_d2 <= CHAR_0;
        shown_r1_d3 <= CHAR_0;
        shown_r2_d0 <= CHAR_0;
        shown_r2_d1 <= CHAR_0;
        shown_r2_d2 <= CHAR_0;
        shown_r2_d3 <= CHAR_0;
        shown_r3_d0 <= CHAR_0;
        shown_r3_d1 <= CHAR_0;
        shown_r3_d2 <= CHAR_0;
        shown_r3_d3 <= CHAR_0;
        shown_r4_d0 <= CHAR_0;
        shown_r4_d1 <= CHAR_0;
        shown_r4_d2 <= CHAR_0;
        shown_r4_d3 <= CHAR_0;
        shown_r5_d0 <= CHAR_0;
        shown_r5_d1 <= CHAR_0;
        shown_r5_d2 <= CHAR_0;
        shown_r5_d3 <= CHAR_0;
        shown_r6_d0 <= CHAR_0;
        shown_r6_d1 <= CHAR_0;
        shown_r6_d2 <= CHAR_0;
        shown_r6_d3 <= CHAR_0;
    end
    else begin
        en <= 1'b0;
        refresh_done <= 1'b0;
        if (xfer_done)
            xfer_started <= 1'b0;
        if (refresh_req)
            refresh_pending <= 1'b1;

        case (cur_state)
            IDLE: begin
                init <= 1'b0;
                command_data <= 1'b0;
                payload_len <= 8'd0;
                data <= 64'd0;
                ssd1309_init_done <= 1'b0;
                init_index <= 5'd0;
                clear_index <= 8'd0;
                row_index <= 3'd0;
                char_index <= 5'd0;
                col_index <= 8'd0;
                value_only_refresh <= 1'b0;
                refresh_pending <= 1'b0;
                xfer_started <= 1'b0;
                label_restore_active <= 1'b0;
                label_restore_row <= 3'd0;
                label_restore_char <= 3'd0;
                dirty_digit <= 2'd0;
                refresh_cnt <= 24'd0;
            end
            I2C_INIT: begin
                en <= can_start_i2c;
                if (can_start_i2c) xfer_started <= 1'b1;
                init <= 1'b1;
                command_data <= 1'b0;
                payload_len <= 8'd0;
                data <= 64'd0;
            end
            INIT_SEND: begin
                en <= can_start_i2c;
                if (can_start_i2c) xfer_started <= 1'b1;
                init <= 1'b0;
                command_data <= 1'b0;
                payload_len <= init_payload_len(init_index);
                data <= init_payload_data(init_index);
                if (xfer_done && init_index < 5'd19)
                    init_index <= init_index + 1'b1;
            end
            CLEAR_COLUMN_ADDR: begin
                en <= can_start_i2c;
                if (can_start_i2c) xfer_started <= 1'b1;
                init <= 1'b0;
                command_data <= 1'b0;
                payload_len <= 8'd3;
                data <= {8'h21, 8'd0, 8'd127};
            end
            CLEAR_PAGE_ADDR: begin
                en <= can_start_i2c;
                if (can_start_i2c) xfer_started <= 1'b1;
                init <= 1'b0;
                command_data <= 1'b0;
                payload_len <= 8'd3;
                data <= {8'h22, 8'd0, 8'd7};
            end
            CLEAR_SCREEN: begin
                en <= can_start_i2c;
                if (can_start_i2c) xfer_started <= 1'b1;
                init <= 1'b0;
                command_data <= 1'b1;
                payload_len <= 8'd8;
                data <= 64'd0;
                if (xfer_done && clear_index < 8'd127)
                    clear_index <= clear_index + 1'b1;
                if (xfer_done && clear_index == 8'd127)
                    ssd1309_init_done <= 1'b1;
            end
            SET_COLUMN_ADDR: begin
                en <= can_start_i2c;
                if (can_start_i2c) xfer_started <= 1'b1;
                init <= 1'b0;
                command_data <= 1'b0;
                payload_len <= 8'd3;
                data <= {8'h21, active_col_start(value_only_refresh, row_index), active_col_end(value_only_refresh, row_index)};
                if (xfer_done) begin
                    char_index <= active_col_start(value_only_refresh, row_index) >> 3;
                    col_index <= 8'd0;
                end
            end
            SET_PAGE_ADDR: begin
                en <= can_start_i2c;
                if (can_start_i2c) xfer_started <= 1'b1;
                init <= 1'b0;
                command_data <= 1'b0;
                payload_len <= 8'd3;
                data <= {8'h22, row_page(row_index), row_page(row_index)};
            end
            WRITE_CHAR: begin
                en <= can_start_i2c;
                if (can_start_i2c) xfer_started <= 1'b1;
                init <= 1'b0;
                command_data <= 1'b1;
                payload_len <= 8'd8;
                data <= (TEST_PATTERN) ? test_pattern_col(row_index, active_write_col) :
                                          char_bitmap(display_char(row_index, char_index));
                if (xfer_done && value_only_refresh && !label_restore_active) begin
                    case (row_index)
                        3'd0: begin
                            case (dirty_digit)
                                2'd0: shown_r0_d0 <= dirty_display_char;
                                2'd1: shown_r0_d1 <= dirty_display_char;
                                2'd2: shown_r0_d2 <= dirty_display_char;
                                default: shown_r0_d3 <= dirty_display_char;
                            endcase
                        end
                        3'd1: begin
                            case (dirty_digit)
                                2'd0: shown_r1_d0 <= dirty_display_char;
                                2'd1: shown_r1_d1 <= dirty_display_char;
                                2'd2: shown_r1_d2 <= dirty_display_char;
                                default: shown_r1_d3 <= dirty_display_char;
                            endcase
                        end
                        3'd2: begin
                            case (dirty_digit)
                                2'd0: shown_r2_d0 <= dirty_display_char;
                                2'd1: shown_r2_d1 <= dirty_display_char;
                                2'd2: shown_r2_d2 <= dirty_display_char;
                                default: shown_r2_d3 <= dirty_display_char;
                            endcase
                        end
                        3'd3: begin
                            case (dirty_digit)
                                2'd0: shown_r3_d0 <= dirty_display_char;
                                2'd1: shown_r3_d1 <= dirty_display_char;
                                2'd2: shown_r3_d2 <= dirty_display_char;
                                default: shown_r3_d3 <= dirty_display_char;
                            endcase
                        end
                        3'd4: begin
                            case (dirty_digit)
                                2'd0: shown_r4_d0 <= dirty_display_char;
                                2'd1: shown_r4_d1 <= dirty_display_char;
                                2'd2: shown_r4_d2 <= dirty_display_char;
                                default: shown_r4_d3 <= dirty_display_char;
                            endcase
                        end
                        3'd5: begin
                            case (dirty_digit)
                                2'd0: shown_r5_d0 <= dirty_display_char;
                                2'd1: shown_r5_d1 <= dirty_display_char;
                                2'd2: shown_r5_d2 <= dirty_display_char;
                                default: shown_r5_d3 <= dirty_display_char;
                            endcase
                        end
                        default: begin
                            case (dirty_digit)
                                2'd0: shown_r6_d0 <= dirty_display_char;
                                2'd1: shown_r6_d1 <= dirty_display_char;
                                2'd2: shown_r6_d2 <= dirty_display_char;
                                default: shown_r6_d3 <= dirty_display_char;
                            endcase
                        end
                    endcase
                end
                if (xfer_done && !value_only_refresh && active_write_col_end < active_col_end(value_only_refresh, row_index)) begin
                    char_index <= char_index + 1'b1;
                    col_index <= col_index + 8'd8;
                end
                if (xfer_done && !value_only_refresh && active_write_col_end >= active_col_end(value_only_refresh, row_index)) begin
                    col_index <= 8'd0;
                    if (row_index == ROW_LAST) begin
                        row_index <= 3'd0;
                        refresh_done <= 1'b1;
                    end
                    else begin
                        row_index <= row_index + 1'b1;
                    end
                end
                if (xfer_done && label_restore_active) begin
                    label_restore_active <= 1'b0;
                    refresh_done <= 1'b1;
                    if (label_restore_char == 3'd6) begin
                        label_restore_char <= 3'd0;
                        if (label_restore_row == ROW_LAST)
                            label_restore_row <= 3'd0;
                        else
                            label_restore_row <= label_restore_row + 1'b1;
                    end
                    else begin
                        label_restore_char <= label_restore_char + 1'b1;
                    end
                end
            end
            FIND_DIRTY_CHAR: begin
                init <= 1'b0;
                command_data <= 1'b0;
                payload_len <= 8'd0;
                data <= 64'd0;
                value_only_refresh <= 1'b1;
                if (dirty_char_changed) begin
                    char_index <= dirty_char_index;
                    col_index <= 8'd0;
                end
                else if (dirty_scan_last) begin
                    row_index <= 3'd0;
                    dirty_digit <= 2'd0;
                    col_index <= 8'd0;
                    refresh_done <= 1'b1;
                end
                else if (dirty_digit == 2'd3) begin
                    dirty_digit <= 2'd0;
                    row_index <= row_index + 1'b1;
                end
                else begin
                    dirty_digit <= dirty_digit + 1'b1;
                end
            end
            RESTORE_LABEL_CHAR: begin
                init <= 1'b0;
                command_data <= 1'b0;
                payload_len <= 8'd0;
                data <= 64'd0;
                value_only_refresh <= 1'b1;
                label_restore_active <= 1'b1;
                row_index <= label_restore_row;
                char_index <= {2'b00, label_restore_char};
                dirty_digit <= 2'd0;
                col_index <= 8'd0;
            end
            WAIT_REFRESH: begin
                init <= 1'b0;
                command_data <= 1'b0;
                payload_len <= 8'd0;
                data <= 64'd0;
                if (!AUTO_REFRESH) begin
                    refresh_cnt <= 24'd0;
                    if (refresh_pending) begin
                        pm1_0_value <= pending_pm1_0_value;
                        pm2_5_value <= pending_pm2_5_value;
                        pm10_value <= pending_pm10_value;
                        p_0_3_value <= pending_p_0_3_value;
                        p_0_5_value <= pending_p_0_5_value;
                        p_1_0_value <= pending_p_1_0_value;
                        reserve0_value <= pending_ch2o_value;
                        value_only_refresh <= 1'b1;
                        refresh_pending <= 1'b0;
                        row_index <= 3'd0;
                        dirty_digit <= 2'd0;
                        col_index <= 8'd0;
                    end
                end
                else if (refresh_cnt == REFRESH_DELAY) begin
                    refresh_cnt <= 24'd0;
                    pm1_0_value <= pending_pm1_0_value;
                    pm2_5_value <= pending_pm2_5_value;
                    pm10_value <= pending_pm10_value;
                    p_0_3_value <= pending_p_0_3_value;
                    p_0_5_value <= pending_p_0_5_value;
                    p_1_0_value <= pending_p_1_0_value;
                    reserve0_value <= pending_ch2o_value;
                    value_only_refresh <= 1'b1;
                    refresh_pending <= 1'b0;
                    row_index <= 3'd0;
                    dirty_digit <= 2'd0;
                    col_index <= 8'd0;
                end
                else begin
                    refresh_cnt <= refresh_cnt + 1'b1;
                    if (refresh_pending) begin
                        refresh_cnt <= 24'd0;
                        pm1_0_value <= pending_pm1_0_value;
                        pm2_5_value <= pending_pm2_5_value;
                        pm10_value <= pending_pm10_value;
                        p_0_3_value <= pending_p_0_3_value;
                        p_0_5_value <= pending_p_0_5_value;
                        p_1_0_value <= pending_p_1_0_value;
                        reserve0_value <= pending_ch2o_value;
                        value_only_refresh <= 1'b1;
                        refresh_pending <= 1'b0;
                        row_index <= 3'd0;
                        dirty_digit <= 2'd0;
                        col_index <= 8'd0;
                    end
                end
            end
            default: begin
                en <= 1'b0;
                init <= 1'b0;
                command_data <= 1'b0;
                payload_len <= 8'd0;
                data <= 64'd0;
            end
        endcase
    end
end

i2c_driver u_i2c_driver(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),

    .en(en),
    .INIT(init),
    .command_data(command_data),
    .payload_len(payload_len),
    .data(data),
    .done(i2c_done),
    .busy(i2c_busy),
    .SCL(SCL),
    .SDA(SDA)
);

endmodule
