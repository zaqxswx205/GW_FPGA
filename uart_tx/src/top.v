module top(
    input sys_clk,
    input sys_rst_n,

    output tx
);


parameter CNT_MAX = 25'd26_999_999;

wire tx_set;
wire tx_done;
wire tx_busy;
reg [24:0] cnt;

assign tx_set = (cnt == CNT_MAX) ? 1'b1 : 1'b0;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        cnt <= 25'd0;
    end
    else if (cnt == CNT_MAX) begin
        cnt <= (tx_busy) ? 25'd0 : cnt;
    end
    else begin
        cnt <= cnt + 1'b1;
    end
end

baud_gen u_baud_gen(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .tx_clk(tx_clk)
);

uart_tx u_uart_tx(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),

    .tx_clk(tx_clk),
    .tx_set(tx_set),
    .tx_data(8'h55),
    .tx_done(tx_done),
    .tx_busy(tx_busy),
    .tx(tx)
);


endmodule