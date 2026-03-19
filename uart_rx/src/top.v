module top(
    input sys_clk,
    input sys_rst_n,

    input rx
);

wire rx_clk;
wire [7:0] rx_data;
wire rx_err;
wire rx_done;


baud_gen u_baud_gen(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    
    .rx_clk(rx_clk)
);

uart_rx u_uart_rx(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),

    .rx_clk(rx_clk),
    .rx(rx),

    .rx_data(rx_data),
    .rx_err(rx_err),
    .rx_done(rx_done)
);

endmodule