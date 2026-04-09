module top(
    input sys_clk,
    input sys_rst_n
);

wire signal_1;

reg signal_1_d;
wire signal_1_r;
wire signal_1_f;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        signal_1_d <= 1'b0;
    end
    else begin
        signal_1_d <= signal_1;
    end
end

assign signal_1_r = signal_1 & ~signal_1_d;
assign signal_1_f = ~signal_1 & signal_1_d;

i2c_clock u_i2c_clock(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .i2c_clk(signal_1),
    .i2c_clk_half(i2c_clk_half)
);

endmodule