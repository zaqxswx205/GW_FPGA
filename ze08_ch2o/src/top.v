module top(
    input sys_clk,
    input sys_rst_n,

    input rx
);

wire data_ready;

ze08_ch2o_data u_ze08_ch2o_data(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .rx(rx),
    .data_ready(data_ready)
);

endmodule