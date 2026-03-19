module uart_tx(
    input sys_clk,
    input sys_rst_n,

    input tx_clk,
    input tx_set,

    output reg tx,
    output reg tx_done,
    output reg tx_busy,
    input [7:0] tx_data
);

reg [7:0] tx_data_buf;
reg [3:0] tx_state;
reg [3:0] bit_cnt;
reg tx_set_buf;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        tx_data_buf <= 8'h0;
    end
    else if (tx_set && tx_state == 4'b0001) begin
        tx_data_buf <= tx_data;
    end
    else begin
        tx_data_buf <= tx_data_buf;
    end
end

// 锁存 tx_set，在「开始发送」那拍清 0，避免回 0001 时仍为 1 再触发一次
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        tx_set_buf <= 1'b0;
    end
    else if (tx_set) begin
        tx_set_buf <= 1'b1;
    end
    else if (tx_clk && tx_state == 4'b0001 && tx_set_buf) begin
        tx_set_buf <= 1'b0;   // 本拍要进 0010，立刻清掉
    end
    else if (tx_done) begin
        tx_set_buf <= 1'b0;
    end
    else begin
        tx_set_buf <= tx_set_buf;
    end
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        tx_state <= 4'b0001;
        bit_cnt <= 4'd0;
        tx_done <= 1'b0;
        tx_busy <= 1'b0;
        tx <= 1'b1;
    end
    else if (tx_clk) begin
        case (tx_state)
            4'b0001:begin
                bit_cnt <= 4'd0;
                tx <= 1'b1;
                tx_done <= 1'b0;
                tx_busy <= (tx_set_buf) ? 1'b1 : 1'b0;
                tx_state <= (tx_set_buf) ? 4'b0010 : 4'b0001;
            end
            4'b0010:begin
                tx <= 1'b0;
                tx_state <= 4'b0100;
            end
            4'b0100:begin
                tx <= tx_data_buf[bit_cnt];
                tx_state <= (bit_cnt == 4'd7) ? 4'b1000 : 4'b0100;
                bit_cnt <= (bit_cnt == 4'd7) ? 4'd0 : bit_cnt + 4'd1;
            end
            4'b1000:begin
                tx <= 1'b1;
                tx_state <= 4'b0001;
                tx_done <= 1'b1;
            end
            default:begin
                tx_state <= 4'b0001;
            end
        endcase
    end
    else begin
        tx_state <= tx_state;
        bit_cnt <= bit_cnt;
        tx_done <= 1'b0;
        tx <= tx;
    end
end

endmodule