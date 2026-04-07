module i2c_send_one_byte(
    input sys_clk,
    input sys_rst_n,

    input i2c_clk,
    input [7:0] data,
    input start,

    output sub_scl,
    inout sda,
    output  out_done,
    output reg need_release
);

parameter IDLE = 11'b000_0000_0001;
parameter STOP = 11'b100_0000_0000;


reg done;
reg done_sync_1;
reg done_sync_2;
reg done_sync_2_d;
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        done_sync1   <= 1'b0;
        done_sync2   <= 1'b0;
        done_sync2_d <= 1'b0;
    end
    else begin
        done_sync1   <= done;        // async source sampled
        done_sync2   <= done_sync1;  // metastability filter
        done_sync2_d <= done_sync2;  // one-cycle delayed
    end
end
assign out_done = done_sync2 & ~done_sync2_d;

reg [10:0] cur_state;
reg [10:0] next_state;

always @(posedge i2c_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        cur_state <= IDLE;
    end
    else begin
        cur_state <= next_state;
    end
end

always @(*) begin
    case (cur_state)
        IDLE: next_state = (start) ? BIT_7 : IDLE;
        default: next_state = IDLE;
    endcase
end

always @(posedge i2c_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        need_release <= 1'b0;
        done <= 1'b0;
    end
    else begin
        case (cur_state)
            IDLE:begin
                need_release <= 1'b0;
                done <= 1'b0;
            end
            STOP:begin
                need_release <= 1'b0;
                done <= 1'b1;
            end
            default:begin
                need_release <= 1'b0;
                done <= 1'b0;
            end
        endcase
    end
end

endmodule