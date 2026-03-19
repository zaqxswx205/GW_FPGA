module fifo_top(
    input sys_clk,
    input sys_rst_n,

    input rx_clk,
    input rx,

    input rd_en,
    output [7:0] rd_data,
    output phase
);

//帧头检测标志位
parameter FRAME_HEAD_1 = 8'h42;
parameter FRAME_HEAD_2 = 8'h4d;

// uart_rx
wire rx_done;
wire rx_err;
wire [7:0] rx_data;

//fifo
wire wr_en;

reg [1:0] frame_head_state;
reg head_valid;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        frame_head_state <= 2'b01;
        head_valid <= 1'b0;
    end
    else if (phase) begin
        frame_head_state <= 2'b01;
        head_valid <= 1'b0;
    end
    else if (!phase && rx_done && !rx_err) begin
        case (frame_head_state)
            2'b01:begin
                frame_head_state <= (rx_data == FRAME_HEAD_1) ? 2'b10 : 2'b01;
            end
            2'b10:begin
                head_valid <= (rx_data == FRAME_HEAD_2) ? 1'b1 : 1'b0;
                frame_head_state <= 2'b01;
            end
            default:begin
                frame_head_state <= 2'b01;
            end
        endcase
    end
    else begin
        frame_head_state <= frame_head_state;
        head_valid <= head_valid;
    end
end

assign wr_en = rx_done && !rx_err && (phase == 1'b0) && head_valid;


uart_rx u_uart_rx(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),

    .rx_clk(rx_clk),
    .rx(rx),
    .rx_done(rx_done),
    .rx_err(rx_err),
    .rx_data(rx_data)
);

fifo u_fifo(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),

    .wr_en(wr_en),
    .wr_data(rx_data),
    .rd_en(rd_en),
    .rd_data(rd_data),
    .phase(phase)
);

endmodule    