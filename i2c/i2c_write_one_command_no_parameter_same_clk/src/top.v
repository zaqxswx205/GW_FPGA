module top(
    input sys_clk,
    input sys_rst_n,

    output scl,
    inout sda

);

parameter CNT_MAX = 12'd999;

reg start;
wire done;
wire busy;
reg [11:0] cnt;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        cnt <= 12'd0;
        start <= 1'b0;
    end
    else if (cnt == CNT_MAX) begin
        if (!busy && !done && !start) begin
            start <= 1'b1;
        end
        else if (done) begin
            cnt <= 12'd0;
        end
        else if (busy) begin
            start <= 1'b0;
        end
    end
    else begin
        cnt <= cnt + 1'b1;
    end
end

i2c_send_single_command u_i2c_send_single_command(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),

    .start(start),
    .command(8'hAE),
    .done(done),
    .busy(busy),
    .scl(scl),
    .sda(sda)

);



endmodule

