module i2c_wait_tip(
    input sys_clk,
    input sys_rst_n,

    input start,
    input [7:0] rdata,
    input [7:0] expected_data,
    input mode,

    output reg rx_en,
    output reg busy,
    output reg done,
    output reg ack_error
);


localparam [5:0]
    IDLE    = 6'b00_0001,
    DECIDE  = 6'b00_0010,
    REG_REQ = 6'b00_0100,
    H_REQ   = 6'b00_1000,
    L_REQ   = 6'b01_0000,
    DONE    = 6'b10_0000;

localparam [19:0] WAIT_TIMEOUT = 20'hfffff;

reg [5:0] cur_state;
reg [5:0] next_state;
reg mode_latched;
reg timeout_hit;
reg [19:0] timeout_cnt;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) cur_state <= IDLE;
    else cur_state <= next_state;
end

always @(*) begin
    case (cur_state)
        IDLE: begin
            if (start) next_state = DECIDE;
            else next_state = IDLE;
        end
        DECIDE: next_state = (mode_latched) ? H_REQ : REG_REQ;
        REG_REQ: next_state = DONE;
    H_REQ: begin
            next_state = (rdata[1] == 1'b1) ? L_REQ : H_REQ;
        end
    L_REQ: begin
            next_state = (rdata[1] == 1'b0) ? DONE : L_REQ;
        end
        DONE: next_state = IDLE;
        default: next_state = IDLE;
    endcase
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        rx_en <= 1'b0;
        busy <= 1'b0;
        done <= 1'b0;
        ack_error <= 1'b0;
        mode_latched <= 1'b0;
        timeout_hit <= 1'b0;
        timeout_cnt <= 20'd0;
    end
    else begin
        done <= 1'b0;
        case (cur_state)
            IDLE:begin
                rx_en <= 1'b0;
                busy <= 1'b0;
                done <= 1'b0;
                ack_error <= 1'b0;
                timeout_hit <= 1'b0;
                timeout_cnt <= 20'd0;
                if (start) mode_latched <= mode;
            end
            DECIDE:begin
                busy <= 1'b0;
                rx_en <= 1'b0;
            end
            REG_REQ:begin
                busy <= 1'b1;
                rx_en <= 1'b1;
            end
            H_REQ:begin
                busy <= 1'b1;
                rx_en <= 1'b1;
                if (timeout_cnt == WAIT_TIMEOUT) timeout_hit <= 1'b1;
                else timeout_cnt <= timeout_cnt + 1'b1;
            end
            L_REQ:begin
                busy <= 1'b1;
                rx_en <= 1'b1;
                if (timeout_cnt == WAIT_TIMEOUT) timeout_hit <= 1'b1;
                else timeout_cnt <= timeout_cnt + 1'b1;
            end
            DONE:begin
                busy <= 1'b0;
                done <= 1'b1;
                rx_en <= 1'b0;
                // mode_latched=0: register readback check
                // mode_latched=1: normal send path check (timeout/ack)
                ack_error <= (mode_latched) ? rdata[7] : (rdata != expected_data);
            end
            default:begin
                busy <= 1'b0;
                done <= 1'b0;
                rx_en <= 1'b0;
                ack_error <= 1'b0;
                timeout_hit <= 1'b0;
                timeout_cnt <= 20'd0;
            end
        endcase
    end
end

endmodule
