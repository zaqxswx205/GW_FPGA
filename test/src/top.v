module top(
    input sys_clk,
    input sys_rst_n
);

localparam [4:0]
    IDLE         = 5'b0_0001,
    INIT         = 5'b0_0010,
    SEND_COMMAND = 5'b0_0100,
    SEND_DATA    = 5'b0_1000,
    DONE         = 5'b1_0000;

reg [4:0] cur_state;
reg [4:0] next_state;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) cur_state <= IDLE;
    else cur_state <= next_state;
end


reg [7:0] byte_cnt;
reg done;
always @(*) begin
    case (cur_state)
        IDLE        : next_state = INIT;
        INIT        : next_state = (byte_cnt == 8'd2) ? SEND_COMMAND : INIT;
        SEND_COMMAND: next_state = (byte_cnt == 8'd2) ? SEND_DATA : SEND_COMMAND;
        SEND_DATA   : next_state = (byte_cnt == 8'd2) ? DONE : SEND_DATA;
        DONE        : next_state = IDLE;
        default: next_state = IDLE;
    endcase
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        byte_cnt <= 8'd0;
        done <= 1'b0;
    end
    else begin
        done <= 1'b0;
        case (cur_state)
            IDLE: begin
                byte_cnt <= 8'd0;
                done <= 1'b0;
            end
            INIT: begin
                byte_cnt <= (byte_cnt == 8'd2) ? 8'd0 : byte_cnt + 8'd1;
            end
            SEND_COMMAND: begin
                byte_cnt <= (byte_cnt == 8'd2) ? 8'd0 : byte_cnt + 8'd1;
            end
            SEND_DATA: begin
                byte_cnt <= (byte_cnt == 8'd2) ? 8'd0 : byte_cnt + 8'd1;
            end
            DONE: begin
                done <= 1'b1;
            end
            default: begin
                byte_cnt <= 8'd0;
                done <= 1'b0;
            end
        endcase
    end 
end

endmodule