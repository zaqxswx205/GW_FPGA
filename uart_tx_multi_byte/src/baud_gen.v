module baud_gen (
    input sys_clk,
    input sys_rst_n,

    output reg tx_clk
);

parameter TX_BAUD_CNT_MAX = 12'd2811;

reg [11:0] tx_cnt;

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

endmodule