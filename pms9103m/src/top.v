module top(
    input sys_clk,
    input sys_rst_n,

    input rx
);

wire data_ready;

pms9103_data u_pms9103_data(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .rx(rx),
    .data_ready(data_ready)
);

endmodule