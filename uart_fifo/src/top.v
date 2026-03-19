module top(
    input sys_clk,
    input sys_rst_n,

    input rx,
    output tx
);



//baud_gen
wire tx_clk;
wire rx_clk;

//uart_rx
wire rx_done;
wire rx_err;
wire [7:0] rx_data;

//uart_tx
wire tx_set;
wire tx_done;
wire tx_busy;

//fifo
wire wr_en;
wire rd_en;
wire        full;
wire        empty;
wire [7:0]  rd_data;

assign wr_en = rx_done && !full;

// 发：uart_tx 内部已锁存 tx_set，top 只需在「有空且非忙」时给 1 拍即可
reg can_send_d;
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)  can_send_d <= 1'b0;
    else             can_send_d <= !tx_busy && !empty;
end
assign tx_set = (!tx_busy && !empty) && !can_send_d;  // 上升沿单拍
assign rd_en  = tx_set;

baud_gen u_baud_gen(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),

    .tx_clk(tx_clk),
    .rx_clk(rx_clk)
);

uart_tx u_uart_tx(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),

    .tx_clk(tx_clk),
    .tx_set(tx_set),

    .tx(tx),
    .tx_done(tx_done),
    .tx_busy(tx_busy),
    .tx_data(rd_data)
);

uart_rx u_uart_rx(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),

    .rx_clk(rx_clk),
    .rx(rx),

    .rx_done(rx_done),
    .rx_err(rx_err),
    .rx_data(rx_data)
);

fifo u_fifo(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),

    .wr_en(wr_en),
    .wr_data(rx_data),
    .full(full),

    .rd_en(rd_en),
    .rd_data(rd_data),
    .empty(empty)
);
endmodule