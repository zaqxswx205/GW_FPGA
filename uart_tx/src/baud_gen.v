module baud_gen(
    input sys_clk,
    input sys_rst_n,

    output reg tx_clk
);

parameter BAUD_CNT = 12'd234;

reg [11:0] baud_cnt;
 
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        baud_cnt <= 12'd0;
    end
    else if (baud_cnt == BAUD_CNT - 1) begin
        baud_cnt <= 12'd0;
        tx_clk <= 1'b1;
    end
    else begin
        baud_cnt <= baud_cnt + 1'b1;
        tx_clk <= 1'b0;
    end
end

endmodule