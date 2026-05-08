module top_ili9488_show_one (
    input  wire sys_clk,
    input  wire sys_rst_n,
    output wire spi_sclk,
    output wire spi_mosi,
    output wire spi_cs_n,
    output wire dcx,
    output wire lcd_rst_n,
    output wire lcd_bl
);

// User-adjustable display settings
localparam integer SYS_CLK_HZ = 27_000_000;
localparam [8:0] TOP_DIGIT_POS_X = 9'd120;
localparam [8:0] TOP_DIGIT_POS_Y = 9'd100;

reg [24:0] sec_cnt;
reg [3:0]  digit_value;
reg        digit_update_req;
wire       digit_update_ack;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        sec_cnt     <= 25'd0;
        digit_value <= 4'd0;
        digit_update_req <= 1'b0;
    end else begin
        if (digit_update_ack)
            digit_update_req <= 1'b0;

        if (sec_cnt == SYS_CLK_HZ - 1) begin
            sec_cnt <= 25'd0;
            if (!digit_update_req) begin
                if (digit_value == 4'd9)
                    digit_value <= 4'd0;
                else
                    digit_value <= digit_value + 4'd1;
                digit_update_req <= 1'b1;
            end
        end else begin
            sec_cnt <= sec_cnt + 25'd1;
        end
    end
end

ili9488_ctrl u_ili9488_ctrl (
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .digit_value(digit_value),
    .digit_update(digit_update_req),
    .digit_pos_x(TOP_DIGIT_POS_X),
    .digit_pos_y(TOP_DIGIT_POS_Y),
    .spi_sclk(spi_sclk),
    .spi_mosi(spi_mosi),
    .spi_cs_n(spi_cs_n),
    .dcx(dcx),
    .lcd_rst_n(lcd_rst_n),
    .lcd_bl(lcd_bl),
    .digit_update_ack(digit_update_ack)
);

endmodule
