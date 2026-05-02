module top (
    input sys_clk,
    input sys_rst_n,

    output init_done,
    inout SCL,
    inout SDA
);

parameter START_COL  = 8'd0;
parameter STOP_COL   = 8'd127;
parameter PAGE_START = 8'd1;
parameter PAGE_END   = 8'd1;

localparam [25:0]
    IDLE              = (26'd1 << 0),
    I2C_INIT          = (26'd1 << 1),
    INIT_CMD_UNLOCK   = (26'd1 << 2),
    INIT_DISPLAY_OFF  = (26'd1 << 3),
    INIT_SCROLL_OFF   = (26'd1 << 4),
    INIT_CLOCK_DIV    = (26'd1 << 5),
    INIT_MUX          = (26'd1 << 6),
    INIT_OFFSET       = (26'd1 << 7),
    INIT_START_LINE   = (26'd1 << 8),
    INIT_SEG_REMAP    = (26'd1 << 9),
    INIT_COM_SCAN     = (26'd1 << 10),
    INIT_COM_PINS     = (26'd1 << 11),
    INIT_CONTRAST     = (26'd1 << 12),
    INIT_DISPLAY_RAM  = (26'd1 << 13),
    INIT_NORMAL_DISP  = (26'd1 << 14),
    INIT_PRECHARGE    = (26'd1 << 15),
    INIT_VCOMH        = (26'd1 << 16),
    INIT_MEMORY_MODE  = (26'd1 << 17),
    INIT_DISPLAY_ON   = (26'd1 << 18),
    CLEAR_COLUMN_ADDR = (26'd1 << 19),
    CLEAR_PAGE_ADDR   = (26'd1 << 20),
    CLEAR_SCREEN      = (26'd1 << 21),
    SET_COLUMN_ADDR   = (26'd1 << 22),
    SET_PAGE_ADDR     = (26'd1 << 23),
    WRITE_PIXEL       = (26'd1 << 24),
    STOP              = (26'd1 << 25);

reg en;
reg init;
reg command_data;
wire i2c_done;
wire i2c_busy;
reg [7:0] payload_len;
reg [63:0] data;

reg ssd1309_init_done;
reg [25:0] cur_state;
reg [25:0] next_state;
reg [3:0] digit_index;
reg [7:0] clear_index;

function [63:0] digit_bitmap;
    input [3:0] digit;
    begin
        case (digit)
            4'd1: digit_bitmap = {8'h00, 8'h00, 8'h42, 8'h7f, 8'h40, 8'h00, 8'h00, 8'h00};
            4'd2: digit_bitmap = {8'h00, 8'h62, 8'h51, 8'h49, 8'h49, 8'h46, 8'h00, 8'h00};
            4'd3: digit_bitmap = {8'h00, 8'h22, 8'h49, 8'h49, 8'h49, 8'h36, 8'h00, 8'h00};
            4'd4: digit_bitmap = {8'h00, 8'h18, 8'h14, 8'h12, 8'h7f, 8'h10, 8'h00, 8'h00};
            4'd5: digit_bitmap = {8'h00, 8'h2f, 8'h49, 8'h49, 8'h49, 8'h31, 8'h00, 8'h00};
            4'd6: digit_bitmap = {8'h00, 8'h3e, 8'h49, 8'h49, 8'h49, 8'h32, 8'h00, 8'h00};
            4'd7: digit_bitmap = {8'h00, 8'h01, 8'h71, 8'h09, 8'h05, 8'h03, 8'h00, 8'h00};
            4'd8: digit_bitmap = {8'h00, 8'h36, 8'h49, 8'h49, 8'h49, 8'h36, 8'h00, 8'h00};
            4'd9: digit_bitmap = {8'h00, 8'h26, 8'h49, 8'h49, 8'h49, 8'h3e, 8'h00, 8'h00};
            default: digit_bitmap = 64'd0;
        endcase
    end
endfunction

assign init_done = ssd1309_init_done;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) cur_state <= IDLE;
    else cur_state <= next_state;
end

always @(*) begin
    case (cur_state)
        IDLE:             next_state = I2C_INIT;
        I2C_INIT:         next_state = (i2c_done) ? INIT_CMD_UNLOCK : I2C_INIT;
        INIT_CMD_UNLOCK:  next_state = (i2c_done) ? INIT_DISPLAY_OFF : INIT_CMD_UNLOCK;
        INIT_DISPLAY_OFF: next_state = (i2c_done) ? INIT_SCROLL_OFF : INIT_DISPLAY_OFF;
        INIT_SCROLL_OFF:  next_state = (i2c_done) ? INIT_CLOCK_DIV : INIT_SCROLL_OFF;
        INIT_CLOCK_DIV:   next_state = (i2c_done) ? INIT_MUX : INIT_CLOCK_DIV;
        INIT_MUX:         next_state = (i2c_done) ? INIT_OFFSET : INIT_MUX;
        INIT_OFFSET:      next_state = (i2c_done) ? INIT_START_LINE : INIT_OFFSET;
        INIT_START_LINE:  next_state = (i2c_done) ? INIT_SEG_REMAP : INIT_START_LINE;
        INIT_SEG_REMAP:   next_state = (i2c_done) ? INIT_COM_SCAN : INIT_SEG_REMAP;
        INIT_COM_SCAN:    next_state = (i2c_done) ? INIT_COM_PINS : INIT_COM_SCAN;
        INIT_COM_PINS:    next_state = (i2c_done) ? INIT_CONTRAST : INIT_COM_PINS;
        INIT_CONTRAST:    next_state = (i2c_done) ? INIT_DISPLAY_RAM : INIT_CONTRAST;
        INIT_DISPLAY_RAM: next_state = (i2c_done) ? INIT_NORMAL_DISP : INIT_DISPLAY_RAM;
        INIT_NORMAL_DISP: next_state = (i2c_done) ? INIT_PRECHARGE : INIT_NORMAL_DISP;
        INIT_PRECHARGE:   next_state = (i2c_done) ? INIT_VCOMH : INIT_PRECHARGE;
        INIT_VCOMH:       next_state = (i2c_done) ? INIT_MEMORY_MODE : INIT_VCOMH;
        INIT_MEMORY_MODE: next_state = (i2c_done) ? INIT_DISPLAY_ON : INIT_MEMORY_MODE;
        INIT_DISPLAY_ON:  next_state = (i2c_done) ? CLEAR_COLUMN_ADDR : INIT_DISPLAY_ON;
        CLEAR_COLUMN_ADDR:next_state = (i2c_done) ? CLEAR_PAGE_ADDR : CLEAR_COLUMN_ADDR;
        CLEAR_PAGE_ADDR:  next_state = (i2c_done) ? CLEAR_SCREEN : CLEAR_PAGE_ADDR;
        CLEAR_SCREEN:     next_state = (i2c_done) ? ((clear_index == 8'd127) ? SET_COLUMN_ADDR : CLEAR_SCREEN) : CLEAR_SCREEN;
        SET_COLUMN_ADDR:  next_state = (i2c_done) ? SET_PAGE_ADDR : SET_COLUMN_ADDR;
        SET_PAGE_ADDR:    next_state = (i2c_done) ? WRITE_PIXEL : SET_PAGE_ADDR;
        WRITE_PIXEL:      next_state = (i2c_done) ? ((digit_index == 4'd9) ? STOP : WRITE_PIXEL) : WRITE_PIXEL;
        STOP:             next_state = STOP;
        default:          next_state = IDLE;
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
        digit_index <= 4'd1;
        clear_index <= 8'd0;
    end
    else begin
        en <= 1'b0;

        if (cur_state == CLEAR_SCREEN && i2c_done && clear_index == 8'd127)
            ssd1309_init_done <= 1'b1;

        case (cur_state)
            IDLE: begin
                init <= 1'b0;
                command_data <= 1'b0;
                payload_len <= 8'd0;
                data <= 64'd0;
                ssd1309_init_done <= 1'b0;
                digit_index <= 4'd1;
                clear_index <= 8'd0;
            end
            I2C_INIT: begin
                en <= (!i2c_busy && !i2c_done) ? 1'b1 : 1'b0;
                init <= 1'b1;
                command_data <= 1'b0;
                payload_len <= 8'd0;
                data <= 64'd0;
            end
            INIT_CMD_UNLOCK: begin
                en <= (!i2c_busy && !i2c_done) ? 1'b1 : 1'b0;
                init <= 1'b0;
                command_data <= 1'b0;
                payload_len <= 8'd2;
                data <= {8'hfd, 8'h12};
            end
            INIT_DISPLAY_OFF: begin
                en <= (!i2c_busy && !i2c_done) ? 1'b1 : 1'b0;
                init <= 1'b0;
                command_data <= 1'b0;
                payload_len <= 8'd1;
                data <= 8'hae;
            end
            INIT_SCROLL_OFF: begin
                en <= (!i2c_busy && !i2c_done) ? 1'b1 : 1'b0;
                init <= 1'b0;
                command_data <= 1'b0;
                payload_len <= 8'd1;
                data <= 8'h2e;
            end
            INIT_CLOCK_DIV: begin
                en <= (!i2c_busy && !i2c_done) ? 1'b1 : 1'b0;
                init <= 1'b0;
                command_data <= 1'b0;
                payload_len <= 8'd2;
                data <= {8'hd5, 8'h80};
            end
            INIT_MUX: begin
                en <= (!i2c_busy && !i2c_done) ? 1'b1 : 1'b0;
                init <= 1'b0;
                command_data <= 1'b0;
                payload_len <= 8'd2;
                data <= {8'ha8, 8'h3f};
            end
            INIT_OFFSET: begin
                en <= (!i2c_busy && !i2c_done) ? 1'b1 : 1'b0;
                init <= 1'b0;
                command_data <= 1'b0;
                payload_len <= 8'd2;
                data <= {8'hd3, 8'h00};
            end
            INIT_START_LINE: begin
                en <= (!i2c_busy && !i2c_done) ? 1'b1 : 1'b0;
                init <= 1'b0;
                command_data <= 1'b0;
                payload_len <= 8'd1;
                data <= 8'h40;
            end
            INIT_SEG_REMAP: begin
                en <= (!i2c_busy && !i2c_done) ? 1'b1 : 1'b0;
                init <= 1'b0;
                command_data <= 1'b0;
                payload_len <= 8'd1;
                data <= 8'ha1;
            end
            INIT_COM_SCAN: begin
                en <= (!i2c_busy && !i2c_done) ? 1'b1 : 1'b0;
                init <= 1'b0;
                command_data <= 1'b0;
                payload_len <= 8'd1;
                data <= 8'hc8;
            end
            INIT_COM_PINS: begin
                en <= (!i2c_busy && !i2c_done) ? 1'b1 : 1'b0;
                init <= 1'b0;
                command_data <= 1'b0;
                payload_len <= 8'd2;
                data <= {8'hda, 8'h12};
            end
            INIT_CONTRAST: begin
                en <= (!i2c_busy && !i2c_done) ? 1'b1 : 1'b0;
                init <= 1'b0;
                command_data <= 1'b0;
                payload_len <= 8'd2;
                data <= {8'h81, 8'h7f};
            end
            INIT_DISPLAY_RAM: begin
                en <= (!i2c_busy && !i2c_done) ? 1'b1 : 1'b0;
                init <= 1'b0;
                command_data <= 1'b0;
                payload_len <= 8'd1;
                data <= 8'ha4;
            end
            INIT_NORMAL_DISP: begin
                en <= (!i2c_busy && !i2c_done) ? 1'b1 : 1'b0;
                init <= 1'b0;
                command_data <= 1'b0;
                payload_len <= 8'd1;
                data <= 8'ha6;
            end
            INIT_PRECHARGE: begin
                en <= (!i2c_busy && !i2c_done) ? 1'b1 : 1'b0;
                init <= 1'b0;
                command_data <= 1'b0;
                payload_len <= 8'd2;
                data <= {8'hd9, 8'h22};
            end
            INIT_VCOMH: begin
                en <= (!i2c_busy && !i2c_done) ? 1'b1 : 1'b0;
                init <= 1'b0;
                command_data <= 1'b0;
                payload_len <= 8'd2;
                data <= {8'hdb, 8'h34};
            end
            INIT_MEMORY_MODE: begin
                en <= (!i2c_busy && !i2c_done) ? 1'b1 : 1'b0;
                init <= 1'b0;
                command_data <= 1'b0;
                payload_len <= 8'd2;
                data <= {8'h20, 8'h00};
            end
            INIT_DISPLAY_ON: begin
                en <= (!i2c_busy && !i2c_done) ? 1'b1 : 1'b0;
                init <= 1'b0;
                command_data <= 1'b0;
                payload_len <= 8'd1;
                data <= 8'haf;
            end
            CLEAR_COLUMN_ADDR: begin
                en <= (!i2c_busy && !i2c_done) ? 1'b1 : 1'b0;
                init <= 1'b0;
                command_data <= 1'b0;
                payload_len <= 8'd3;
                data <= {8'h21, 8'd0, 8'd127};
            end
            CLEAR_PAGE_ADDR: begin
                en <= (!i2c_busy && !i2c_done) ? 1'b1 : 1'b0;
                init <= 1'b0;
                command_data <= 1'b0;
                payload_len <= 8'd3;
                data <= {8'h22, 8'd0, 8'd7};
            end
            CLEAR_SCREEN: begin
                en <= (!i2c_busy && !i2c_done) ? 1'b1 : 1'b0;
                init <= 1'b0;
                command_data <= 1'b1;
                payload_len <= 8'd8;
                data <= 64'd0;
                if (i2c_done && clear_index < 8'd127)
                    clear_index <= clear_index + 1'b1;
            end
            SET_COLUMN_ADDR: begin
                en <= (!i2c_busy && !i2c_done) ? 1'b1 : 1'b0;
                init <= 1'b0;
                command_data <= 1'b0;
                payload_len <= 8'd3;
                data <= {8'h21, START_COL, STOP_COL};
            end
            SET_PAGE_ADDR: begin
                en <= (!i2c_busy && !i2c_done) ? 1'b1 : 1'b0;
                init <= 1'b0;
                command_data <= 1'b0;
                payload_len <= 8'd3;
                data <= {8'h22, PAGE_START, PAGE_END};
            end
            WRITE_PIXEL: begin
                en <= (!i2c_busy && !i2c_done) ? 1'b1 : 1'b0;
                init <= 1'b0;
                command_data <= 1'b1;
                payload_len <= 8'd8;
                data <= digit_bitmap(digit_index);
                if (i2c_done && digit_index < 4'd9)
                    digit_index <= digit_index + 1'b1;
            end
            STOP: begin
                en <= 1'b0;
                init <= 1'b0;
                command_data <= 1'b0;
                payload_len <= 8'd0;
                data <= 64'd0;
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
