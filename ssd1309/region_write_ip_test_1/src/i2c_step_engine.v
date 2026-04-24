module i2c_step_engine(
    input sys_clk,
    input sys_rst_n,

    input start_step,

    input op0_tx_valid,
    input [2:0] op0_waddr,
    input [7:0] op0_wdata,

    input op1_tx_valid,
    input [2:0] op1_waddr,
    input [7:0] op1_wdata,
    input op1_mode,
    input [2:0] op1_raddr,
    input [7:0] op1_match_data,

    input use_phase2,
    input op2_mode,
    input [2:0] op2_raddr,
    input [7:0] op2_match_data,

    input wait_done,

    output reg tx_en,
    output reg [2:0] waddr,
    output reg [7:0] wdata,
    output reg start,
    output reg mode,
    output reg [2:0] raddr,
    output reg [7:0] match_data,
    output reg running,
    output reg done,
    output reg [1:0] phase
);

localparam [2:0] CHECK_SEND = 3'd4;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        tx_en <= 1'b0;
        waddr <= 3'd0;
        wdata <= 8'd0;
        start <= 1'b0;
        mode <= 1'b0;
        raddr <= CHECK_SEND;
        match_data <= 8'd0;
        running <= 1'b0;
        done <= 1'b0;
        phase <= 2'd0;
    end
    else begin
        tx_en <= 1'b0;
        start <= 1'b0;
        done <= 1'b0;

        if (start_step && !running) begin
            running <= 1'b1;
            phase <= 2'd0;
        end
        else if (running) begin
            case (phase)
                2'd0: begin
                    if (op0_tx_valid) begin
                        tx_en <= 1'b1;
                        waddr <= op0_waddr;
                        wdata <= op0_wdata;
                    end
                    phase <= 2'd1;
                end
                2'd1: begin
                    if (op1_tx_valid) begin
                        tx_en <= 1'b1;
                        waddr <= op1_waddr;
                        wdata <= op1_wdata;
                    end
                    mode <= op1_mode;
                    raddr <= op1_raddr;
                    match_data <= op1_match_data;
                    phase <= (use_phase2) ? 2'd2 : 2'd3;
                end
                2'd2: begin
                    mode <= op2_mode;
                    raddr <= op2_raddr;
                    match_data <= op2_match_data;
                    phase <= 2'd3;
                end
                2'd3: begin
                    start <= 1'b1;
                    if (wait_done) begin
                        running <= 1'b0;
                        done <= 1'b1;
                        phase <= 2'd0;
                    end
                end
                default: begin
                    phase <= 2'd0;
                end
            endcase
        end
    end
end

endmodule
