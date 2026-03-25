module top(
    input sys_clk,
    input sys_rst_n,

    input rx,
    output tx
);


//uart_tx
wire tx_done;
wire tx_busy;

//uart_rx
wire rx_clk;
wire [7:0] rx_data;
wire rx_done;
wire rx_err;

uart_tx u_uart_tx(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),

    .tx_clk(tx_clk),
    .tx_set(rx_done),
    
    .tx_done(tx_done),
    .tx_busy(tx_busy),
    .tx(tx),

    .tx_data(rx_data)
);

uart_rx u_uart_rx(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),

    .rx_clk(rx_clk),
    .rx(rx),

    .rx_data(rx_data),
    .rx_done(rx_done),
    .rx_err(rx_err)
);

endmodule