module uart_tx(
    input sys_clk,
    input sys_rst_n,

    input tx_set,

    output reg tx_clk,
    output reg tx,
    output reg tx_done,
    output reg tx_busy,
    input [7:0] tx_data
);

parameter BAUD_CNT = 12'd2813;

parameter IDLE = 4'b0001;
parameter START = 4'b0010;
parameter DATA = 4'b0100;
parameter STOP = 4'b1000;


reg tx_clk;
reg [11:0] baud_cnt;

reg [7:0] tx_data_buf;
reg [3:0] tx_state;
reg [3:0] bit_cnt;
reg tx_set_buf;

// 锁存 tx_set，在「开始发送」那拍清 0，避免回 0001 时仍为 1 再触发一次
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        tx_set_buf <= 1'b0;
    end
    else if (tx_set) begin
        tx_set_buf <= 1'b1;
    end
    else if (tx_state == IDLE && tx_set_buf) begin
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
        tx_state <= IDLE;
        bit_cnt <= 4'd0;
        tx_done <= 1'b0;
        tx_busy <= 1'b0;
        tx <= 1'b1;
    end
    else begin
        case (tx_state)
            IDLE:begin
                bit_cnt <= 4'd0;
                tx <= 1'b1;
                tx_done <= 1'b0;
                tx_data_buf <= (tx_set_buf) ? tx_data : tx_data_buf;
                tx_busy <= (tx_set_buf) ? 1'b1 : 1'b0;
                tx_state <= (tx_set_buf) ? START : IDLE;
            end
            START:begin
                tx <= (tx_clk) ? 1'b0 : 1'b1;
                tx_state <= (tx_clk) ? DATA : START;
            end
            DATA:begin
                if (tx_clk) begin
                    tx <= tx_data_buf[bit_cnt];
                    tx_state <= (bit_cnt == 4'd7) ? STOP : DATA;
                    bit_cnt <= (bit_cnt == 4'd7) ? 4'd0 : bit_cnt + 4'd1;
                end
                else begin
                    tx <= tx;
                    tx_state <= tx_state;
                    bit_cnt <= bit_cnt;
                end
            end
            STOP:begin
                tx <= (tx_clk) ? 1'b1 : tx;
                tx_state <= (tx_clk) ? IDLE : STOP;
                tx_done <= (tx_clk) ? 1'b1 : 1'b0;
            end
            default:begin
                tx_state <= IDLE;
            end
        endcase
    end
end


always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        baud_cnt <= 12'd0;
    end
    else if (baud_cnt == BAUD_CNT - 1) begin
        baud_cnt <= 12'd0;
        tx_clk <= 1'b1;
    end
    else begin
        baud_cnt <= baud_cnt + 1'b1;
        tx_clk <= 1'b0;
    end
end

endmodule