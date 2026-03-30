module i2c_clock(
    input sys_clk,
    input sys_rst_n,

    output reg i2c_clk
);


parameter CNT_MAX = 6'd33;

reg [5:0] cnt;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        cnt <= 6'd0;
        i2c_clk <= 1'b1;
    end
    else if (cnt == CNT_MAX) begin
        cnt <= 6'd0;
        i2c_clk <= ~i2c_clk;
    end
    else begin
        cnt <= cnt + 1'b1;
    end
end


endmodule