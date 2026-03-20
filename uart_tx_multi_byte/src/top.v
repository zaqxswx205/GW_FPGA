module top (
    input sys_clk,
    input sys_rst_n,

    output tx
);

parameter CNT_BYTE_1 = 25'd26_999_999;
parameter CNT_BYTE_2 = 26'd53_999_999;

wire tx_clk;
wire data_set;
wire send_set;

reg [25:0] cnt;

assign send_set = (cnt == CNT_BYTE_1 || cnt == CNT_BYTE_2) ? 1'b1 : 1'b0;
assign data_set = (cnt == CNT_BYTE_1) ? 1'b1 : 1'b0;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        cnt <= 26'd0;
    end
    else if (cnt == CNT_BYTE_2) begin
        cnt <= 26'd0;
    end
    else begin
        cnt <= cnt + 1'b1;
    end
end
        

mulit_tx_top u_mulit_tx_top(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),

    .tx_clk(tx_clk),
    .data_set(data_set),
    .send_set(send_set),
    .tx(tx)
);

baud_gen u_baud_gen(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .tx_clk(tx_clk)
);



endmodule