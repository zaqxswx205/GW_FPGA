module top (
    input sys_clk,
    input sys_rst_n,

    output init_done,
    inout SCL,
    inout SDA
);

ssd1309_driver #(
    .AUTO_REFRESH(1'b0),
    .TEST_PATTERN(1'b0),
    .VALUE_COL_START(8'd56),
    .VALUE_COL_END(8'd95),
    .ROW0_PAGE(8'd0),
    .ROW0_COL_START(8'd0),
    .ROW0_COL_END(8'd127),
    .ROW1_PAGE(8'd1),
    .ROW1_COL_START(8'd0),
    .ROW1_COL_END(8'd127),
    .ROW2_PAGE(8'd2),
    .ROW2_COL_START(8'd0),
    .ROW2_COL_END(8'd127),
    .ROW3_PAGE(8'd3),
    .ROW3_COL_START(8'd0),
    .ROW3_COL_END(8'd127),
    .ROW4_PAGE(8'd4),
    .ROW4_COL_START(8'd0),
    .ROW4_COL_END(8'd127),
    .ROW5_PAGE(8'd5),
    .ROW5_COL_START(8'd0),
    .ROW5_COL_END(8'd127),
    .ROW6_PAGE(8'd6),
    .ROW6_COL_START(8'd0),
    .ROW6_COL_END(8'd127),
    .ROW7_PAGE(8'd7),
    .ROW7_COL_START(8'd0),
    .ROW7_COL_END(8'd127),
    .ROW0_ITEM(4'd0),
    .ROW1_ITEM(4'd1),
    .ROW2_ITEM(4'd2),
    .ROW3_ITEM(4'd3),
    .ROW4_ITEM(4'd4),
    .ROW5_ITEM(4'd5),
    .ROW6_ITEM(4'd9),
    .ROW7_ITEM(4'd10)
) u_ssd1309_driver (
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .init_done(init_done),
    .refresh_done(),
    .SCL(SCL),
    .SDA(SDA)
);

endmodule
