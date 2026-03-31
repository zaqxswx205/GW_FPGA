module i2c_send(
    input sys_clk,
    input sys_rst_n,

    input i2c_clk,
    input [7:0] data,
    input start,

    output reg scl,
    output reg sda_out,
    output reg done,
    output reg need_release//1是输入，0是输出
);

parameter IDLE       = 11'b000_0000_0001;
parameter BIT_0_SEND = 11'b000_0000_0010;
parameter BIT_1_SEND = 11'b000_0000_0100;
parameter BIT_2_SEND = 11'b000_0000_1000;
parameter BIT_3_SEND = 11'b000_0001_0000;
parameter BIT_4_SEND = 11'b000_0010_0000;
parameter BIT_5_SEND = 11'b000_0100_0000;
parameter BIT_6_SEND = 11'b000_1000_0000;
parameter BIT_7_SEND = 11'b001_0000_0000;
parameter ACK        = 11'b010_0000_0000;
parameter STOP_SEND  = 11'b100_0000_0000;

reg [10:0] cur_state;
reg [10:0] next_state;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        cur_state <= IDLE;
    end
    else begin
        cur_state <= next_state;
    end
end

always @(posedge i2c_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        scl <= 1'b1;
    end
    else if (start) begin
        scl <= ~scl;
    end
    else begin
        scl <= scl;
    end
end

always @(negedge scl or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        sda_out <= 1'b1;
        need_release <= 1'b0;
        done <= 1'b0;
    end
    else begin
        case (cur_state)
            IDLE:begin
                done <= 1'b0;
                sda_out <= 1'b1;
                need_release <= 1'b0;
                next_state = (start) ? BIT_0_SEND : IDLE;
            end
            BIT_0_SEND:begin
                sda_out <= data[7];
                need_release <= 1'b0;
                next_state = BIT_1_SEND;
            end
            BIT_1_SEND:begin
                sda_out <= data[6];
                need_release <= 1'b0;
                next_state = BIT_2_SEND;
            end
            BIT_2_SEND:begin
                sda_out <= data[5];
                need_release <= 1'b0;
                next_state = BIT_3_SEND;
            end
            BIT_3_SEND:begin
                sda_out <= data[4];
                need_release <= 1'b0;
                next_state = BIT_4_SEND;
            end
            BIT_4_SEND:begin
                sda_out <= data[3];
                need_release <= 1'b0;
                next_state = BIT_5_SEND;
            end
            BIT_5_SEND:begin
                sda_out <= data[2];
                need_release <= 1'b0;
                next_state = BIT_6_SEND;
            end
            BIT_6_SEND:begin
                sda_out <= data[1];
                need_release <= 1'b0;
                next_state = BIT_7_SEND;
            end
            BIT_7_SEND:begin
                sda_out <= data[0];
                need_release <= 1'b0;
                next_state = ACK;
            end
            ACK:begin
                sda_out <= 1'b1;
                need_release <= 1'b1;
                next_state = STOP_SEND;
            end
            STOP_SEND:begin
                sda_out <= 1'b1;
                need_release <= 1'b0;
                done <= 1'b1;
                next_state = IDLE;
            end
            default:begin
                sda_out <= 1'b1;
                need_release <= 1'b0;
            end
        endcase
    end
end



endmodule