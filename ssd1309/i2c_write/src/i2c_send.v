// I2C byte send: 8 data bits + ACK clock, single clock domain (i2c_clk).
// sys_clk kept for hierarchical port compatibility (unused).
module i2c_send(
    input wire sys_clk,
    input wire sys_rst_n,

    input wire i2c_clk,
    input wire [7:0] data,
    input wire start,

    output reg scl,
    output reg sda_out,
    output reg done,
    output reg need_release
);

    // Half-period steps: even = SCL low, odd = SCL high (MSB first).
    // 0..15: 8 data bits; 16..17: ACK; then pulse done.
    reg        active;
    reg [4:0]  half_cnt;

    always @(posedge i2c_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            scl          <= 1'b1;
            sda_out      <= 1'b1;
            done         <= 1'b0;
            need_release <= 1'b0;
            active       <= 1'b0;
            half_cnt     <= 5'd0;
        end else if (!start) begin
            scl          <= 1'b1;
            sda_out      <= 1'b1;
            done         <= 1'b0;
            need_release <= 1'b0;
            active       <= 1'b0;
            half_cnt     <= 5'd0;
        end else begin
            done <= 1'b0;
            if (!active) begin
                active       <= 1'b1;
                half_cnt     <= 5'd0;
                scl          <= 1'b0;
                sda_out      <= data[7];
                need_release <= 1'b0;
            end else begin
                if (half_cnt[0] == 1'b0) begin
                    scl      <= 1'b1;
                    half_cnt <= half_cnt + 1'b1;
                end else begin
                    if (half_cnt == 5'd17) begin
                        done         <= 1'b1;
                        active       <= 1'b0;
                        need_release <= 1'b0;
                        scl          <= 1'b1;
                        sda_out      <= 1'b1;
                    end else begin
                        scl      <= 1'b0;
                        half_cnt <= half_cnt + 1'b1;
                        case (half_cnt + 1'b1)
                            5'd2:  sda_out <= data[6];
                            5'd4:  sda_out <= data[5];
                            5'd6:  sda_out <= data[4];
                            5'd8:  sda_out <= data[3];
                            5'd10: sda_out <= data[2];
                            5'd12: sda_out <= data[1];
                            5'd14: sda_out <= data[0];
                            5'd16: begin
                                need_release <= 1'b1;
                                sda_out      <= 1'b1;
                            end
                            default: ;
                        endcase
                    end
                end
            end
        end
    end

endmodule
