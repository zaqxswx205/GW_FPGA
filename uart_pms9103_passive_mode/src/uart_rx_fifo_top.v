module uart_rx_fifo_top(
    input sys_clk,
    input sys_rst_n,


    input rx_clk,
    input rx,

    input rd_en,
    output full,
    output empty,
    output [7:0] rd_data

);

wire [7:0] rx_data;
wire rx_done;
wire rx_err;


uart_rx u_uart_rx(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),

    .rx_clk(rx_clk),
    .rx(rx),
    .rx_done(rx_done),
    .rx_err(rx_err),
    .rx_data(rx_data)
);

loop_fifo u_loop_fifo(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),

    .wr_data(rx_data),
    .wr_en(rx_done),
    .full(full),

    .rd_data(rd_data),
    .rd_en(rd_en),
    .empty(empty)
);


endmodule