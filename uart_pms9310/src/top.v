module top(
    input sys_clk,
    input sys_rst_n,

    input rx,
    output tx
);

//42 4D 00 1C 00 61 00 64 00 69 00 40 00 48 00 5A 0B D1 08 47 00 78 00 03 00 02 00 01 20 00 04 84
// baud_gen
wire tx_clk;
wire rx_clk;

// uart_tx
wire tx_set;
wire tx_done;
wire tx_busy;

//fifo
wire phase;
wire [7:0] rd_data;


// 仅在读阶段且发送器空闲时触发一次发送
reg can_send_d;
wire can_send_now = (phase == 1'b1) && !tx_busy;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        can_send_d <= 1'b0;
    end else begin
        can_send_d <= can_send_now;
    end
end

assign tx_set = can_send_now && !can_send_d; // 上升沿单拍
assign rd_en  = tx_set;                      // 触发发送同拍读FIFO

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

fifo_top u_fifo_top(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),

    .rx_clk(rx_clk),
    .rx(rx),
    .rd_en(rd_en),
    .rd_data(rd_data),
    .phase(phase)
);

endmodule