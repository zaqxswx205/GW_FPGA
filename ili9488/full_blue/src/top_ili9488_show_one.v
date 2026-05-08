module top_ili9488_show_one (
    input  wire sys_clk,
    input  wire sys_rst_n,
    output wire spi_sclk,
    output wire spi_mosi,
    output wire spi_cs_n,
    output wire dcx,
    output wire lcd_rst_n,
    output wire lcd_bl,
    output wire la_sclk,
    output wire la_mosi,
    output wire la_cs_n,
    output wire la_dcx
);

ili9488_ctrl u_ili9488_ctrl (
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .spi_sclk(spi_sclk),
    .spi_mosi(spi_mosi),
    .spi_cs_n(spi_cs_n),
    .dcx(dcx),
    .lcd_rst_n(lcd_rst_n),
    .lcd_bl(lcd_bl)
);

assign la_sclk = spi_sclk;
assign la_mosi = spi_mosi;
assign la_cs_n = spi_cs_n;
assign la_dcx  = dcx;

endmodule
