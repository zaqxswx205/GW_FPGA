module i2c_send_one_byte(
    input sys_clk,
    input sys_rst_n,

    input i2c_clk,
    input [7:0] data,
    input start,
    output out_busy,

    output reg sub_scl,
    output reg sda_out,
    input sda_in,
    output  out_done,
    output reg error,
    output reg need_release
);

parameter IDLE    = 11'b000_0000_0001;
parameter BIT_7   = 11'b000_0000_0010;
parameter BIT_6   = 11'b000_0000_0100;
parameter BIT_5   = 11'b000_0000_1000;
parameter BIT_4   = 11'b000_0001_0000;
parameter BIT_3   = 11'b000_0010_0000;
parameter BIT_2   = 11'b000_0100_0000;
parameter BIT_1   = 11'b000_1000_0000;
parameter BIT_0   = 11'b001_0000_0000;
parameter BIT_ACK = 11'b010_0000_0000;
parameter STOP    = 11'b100_0000_0000;


reg done;
reg done_sync1;
reg done_sync2;
reg done_sync2_d;
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

reg busy;
reg busy_sync1;
reg busy_sync2;
reg busy_sync2_d;
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        busy_sync1 <= 1'b0;
        busy_sync2 <= 1'b0;
        busy_sync2_d <= 1'b0;
    end
    else begin
        busy_sync1 <= busy;
        busy_sync2 <= busy_sync1;
        busy_sync2_d <= busy_sync2;
    end
end
assign out_busy = busy_sync2 & ~busy_sync2_d;

reg [10:0] cur_state;
reg [10:0] next_state;
reg pulse_cnt;

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
        BIT_7: next_state = (pulse_cnt) ? BIT_6 : BIT_7;
        BIT_6: next_state = (pulse_cnt) ? BIT_5 : BIT_6;
        BIT_5: next_state = (pulse_cnt) ? BIT_4 : BIT_5;
        BIT_4: next_state = (pulse_cnt) ? BIT_3 : BIT_4;
        BIT_3: next_state = (pulse_cnt) ? BIT_2 : BIT_3;
        BIT_2: next_state = (pulse_cnt) ? BIT_1 : BIT_2;
        BIT_1: next_state = (pulse_cnt) ? BIT_0 : BIT_1;
        BIT_0: next_state = (pulse_cnt) ? BIT_ACK : BIT_0;
        BIT_ACK: next_state = (pulse_cnt) ? STOP : BIT_ACK;
        STOP: next_state = IDLE;
        default: next_state = IDLE;
    endcase
end

always @(posedge i2c_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        sub_scl <= 1'b1;
    end
    else begin
        case (cur_state)
            IDLE: sub_scl <= 1'b0;
            BIT_7: sub_scl <= (pulse_cnt) ? 1'b1 : 1'b0;
            BIT_6: sub_scl <= (pulse_cnt) ? 1'b1 : 1'b0;
            BIT_5: sub_scl <= (pulse_cnt) ? 1'b1 : 1'b0;
            BIT_4: sub_scl <= (pulse_cnt) ? 1'b1 : 1'b0;
            BIT_3: sub_scl <= (pulse_cnt) ? 1'b1 : 1'b0;
            BIT_2: sub_scl <= (pulse_cnt) ? 1'b1 : 1'b0;
            BIT_1: sub_scl <= (pulse_cnt) ? 1'b1 : 1'b0;
            BIT_0: sub_scl <= (pulse_cnt) ? 1'b1 : 1'b0;
            BIT_ACK: sub_scl <= (pulse_cnt) ? 1'b1 : 1'b0;
            STOP: sub_scl <=  1'b0;
            default: sub_scl <= 1'b0;
        endcase
    end
end

always @(posedge i2c_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        need_release <= 1'b0;
        done <= 1'b0;
        pulse_cnt <= 1'b0;
        sda_out <= 1'b1;
        busy <= 1'b0;
        error <= 1'b0;
    end
    else begin
        case (cur_state)
            IDLE:begin
                need_release <= 1'b0;
                done <= 1'b0;
                pulse_cnt <= 1'b0;
                busy <= 1'b0;
                error <= 1'b0;
            end
            BIT_7:begin
                need_release <= 1'b0;
                sda_out <= data[7];
                pulse_cnt <= pulse_cnt + 1'b1;
                busy <= 1'b1;
            end
            BIT_6:begin
                need_release <= 1'b0;
                sda_out <= data[6];
                pulse_cnt <= pulse_cnt + 1'b1;
            end
            BIT_5:begin
                need_release <= 1'b0;
                sda_out <= data[5];
                pulse_cnt <= pulse_cnt + 1'b1;
            end
            BIT_4:begin
                need_release <= 1'b0;
                sda_out <= data[4];
                pulse_cnt <= pulse_cnt + 1'b1;
            end
            BIT_3:begin
                need_release <= 1'b0;
                sda_out <= data[3];
                pulse_cnt <= pulse_cnt + 1'b1;
            end
            BIT_2:begin
                need_release <= 1'b0;
                sda_out <= data[2];
                pulse_cnt <= pulse_cnt + 1'b1;
            end
            BIT_1:begin
                need_release <= 1'b0;
                sda_out <= data[1];
                pulse_cnt <= pulse_cnt + 1'b1;
            end
            BIT_0:begin
                need_release <= 1'b0;
                sda_out <= data[0];
                pulse_cnt <= pulse_cnt + 1'b1;
            end
            BIT_ACK:begin
                need_release <= 1'b1;
                error <= sda_in;
                pulse_cnt <= pulse_cnt + 1'b1;
            end
            STOP:begin
                need_release <= 1'b0;
                done <= 1'b1;
                busy <= 1'b0;
            end
            default:begin
                need_release <= 1'b0;
                done <= 1'b0;
            end
        endcase
    end
end

endmodule