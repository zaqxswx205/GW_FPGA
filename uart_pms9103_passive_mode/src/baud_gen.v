module baud_gen (
    input sys_clk,
    input sys_rst_n,

    output reg tx_clk,
    output reg rx_clk
);

parameter TX_BAUD_CNT_MAX = 12'd2811;
parameter RX_BAUD_CNT_MAX = 12'd172;

// parameter TX_BAUD_CNT_MAX = 12'd234;
// parameter RX_BAUD_CNT_MAX = 12'd14;

reg [11:0] tx_cnt;
reg [11:0] rx_cnt;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        tx_cnt <= 12'd0;
    end
    else if (tx_cnt == TX_BAUD_CNT_MAX - 1'b1) begin
        tx_cnt <= 12'd0;
        tx_clk <= 1'b1;
    end
    else begin
        tx_cnt <= tx_cnt + 1'b1;
        tx_clk <= 1'b0;
    end
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        rx_cnt <= 12'd0;
    end
    else if (rx_cnt == RX_BAUD_CNT_MAX - 1'b1) begin
        rx_cnt <= 12'd0;
        rx_clk <= 1'b1;
    end
    else begin
        rx_cnt <= rx_cnt + 1'b1;
        rx_clk <= 1'b0;
    end
end

endmodule