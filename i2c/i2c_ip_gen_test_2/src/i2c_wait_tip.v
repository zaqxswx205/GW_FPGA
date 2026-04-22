module i2c_wait_tip(
    input sys_clk,
    input sys_rst_n,

    input start,
    input [7:0] rdata,

    output reg rx_en,
    output reg busy,
    output reg done
);


localparam [3:0]
    IDLE  = 4'b0001,
    H_REQ = 4'b0010,
    L_REQ = 4'b0100,
    DONE  = 4'b1000;


reg [3:0] cur_state;
reg [3:0] next_state;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) cur_state <= IDLE;
    else cur_state <= next_state;
end

always @(*) begin
    case (cur_state)
        IDLE: next_state = (start) ? H_REQ : IDLE;
        H_REQ: next_state = (rdata[1] == 1'b1) ? L_REQ : H_REQ;
        L_REQ: next_state = (rdata[1] == 1'b0) ? DONE : L_REQ;
        DONE: next_state = IDLE;
        default: next_state = IDLE;
    endcase
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        rx_en <= 1'b0;
        busy <= 1'b0;
        done <= 1'b0;
    end
    else begin
        done <= 1'b0;
        case (cur_state)
            IDLE:begin
                rx_en <= 1'b0;
                busy <= 1'b0;
                done <= 1'b0;
            end
            H_REQ:begin
                busy <= 1'b1;
                rx_en <= 1'b1;
            end
            L_REQ:begin
                busy <= 1'b1;
                rx_en <= 1'b1;
            end
            DONE:begin
                busy <= 1'b0;
                done <= 1'b1;
                rx_en <= 1'b0;
            end
            default:begin
                busy <= 1'b0;
                done <= 1'b0;
                rx_en <= 1'b0;
            end
        endcase
    end
end

endmodule