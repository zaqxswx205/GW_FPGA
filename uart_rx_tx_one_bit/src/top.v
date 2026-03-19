module top(
    input sys_clk,
    input sys_rst_n,

    input rx,
    output tx
);



wire tx_clk;
wire tx_set;
wire tx_done;
wire [7:0] tx_data;
wire tx_busy;

wire rx_clk;
wire [7:0] rx_data;
wire rx_done;
wire rx_err;

reg tx_set_buf;

assign tx_set = tx_set_buf;
assign tx_data = rx_data;

// 收到一帧置 1，真正开始发送(tx_busy)时清 0，避免发完回 idle 时 tx_set 仍为 1 导致再发一字节
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        tx_set_buf <= 1'b0;
    end
    else if (rx_done && !rx_err) begin
        tx_set_buf <= 1'b1;
    end
    else if (tx_busy) begin
        tx_set_buf <= 1'b0;
    end
    else begin
        tx_set_buf <= tx_set_buf;
    end
end

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
    
    .tx_done(tx_done),
    .tx_busy(tx_busy),
    .tx(tx),

    .tx_data(tx_data)
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