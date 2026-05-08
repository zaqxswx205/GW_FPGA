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
localparam [3:0] TOP_DIGIT_VALUE = 4'd1;
localparam [8:0] TOP_DIGIT_POS_X = 9'd120;
localparam [8:0] TOP_DIGIT_POS_Y = 9'd100;

ili9488_ctrl u_ili9488_ctrl (
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .digit_value(TOP_DIGIT_VALUE),
    .digit_pos_x(TOP_DIGIT_POS_X),
    .digit_pos_y(TOP_DIGIT_POS_Y),
    .spi_sclk(spi_sclk),
    .spi_mosi(spi_mosi),
    .spi_cs_n(spi_cs_n),
    .dcx(dcx),
    .lcd_rst_n(lcd_rst_n),
    .lcd_bl(lcd_bl)
);

endmodule
