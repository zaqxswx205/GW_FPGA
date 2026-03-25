module uart_rx(
    input sys_clk,
    input sys_rst_n,

    input rx,

    output reg rx_clk,

    output reg rx_done,
    output reg rx_err,
    output reg [7:0] rx_data
);

parameter IDLE = 4'b0001;
parameter START = 4'b0010;
parameter RECEIVE = 4'b0100;
parameter DONE = 4'b1000;

parameter RX_BAUD_CNT = 9'd175;
// parameter RX_BAUD_CNT = 9'd13;
reg [8:0] rx_cnt;

reg [1:0] rx_sync;
wire rx_syn = rx_sync[1];

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        rx_sync <= 2'b11;
    end
    else begin
        rx_sync <= {rx_sync[0], rx};
    end
end

reg [3:0] rx_state;
reg [3:0] bit_cnt;
reg [3:0] sample_cnt;
reg [7:0] rx_data_buf;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        rx_state <= IDLE;
        rx_done <= 1'b0;
        rx_err <= 1'b0;
        bit_cnt <= 4'd0;
        sample_cnt <= 4'd0;
    end
    else begin
        case (rx_state)
            IDLE:begin
                rx_done <= 1'b0;
                bit_cnt <= 4'd0;
                sample_cnt <= 4'd0;
                rx_err <= 1'b0;
                rx_state <= (rx_syn) ? IDLE : START;
            end
            START:begin
                if (rx_clk) begin
                    if (sample_cnt == 4'd7) begin
                        sample_cnt <= sample_cnt + 1'b1;
                        rx_err <= rx_syn;
                    end
                    else if (sample_cnt == 4'd15) begin
                        rx_state <= (rx_err) ? IDLE : RECEIVE;
                        sample_cnt <= 4'd0;
                    end
                    else begin
                        sample_cnt <= sample_cnt + 1'b1;
                    end
                end
                else begin
                    sample_cnt <= sample_cnt;
                end
            end
            RECEIVE:begin
                if (rx_clk) begin
                    if (sample_cnt == 4'd7) begin
                        rx_data_buf <= {rx_syn, rx_data_buf[7:1]};
                        sample_cnt <= sample_cnt + 1'b1;
                    end
                    else if (sample_cnt == 4'd15) begin
                        sample_cnt <= 4'd0;
                        if (bit_cnt == 4'd7) begin
                            bit_cnt <= 4'd0;
                            rx_state <= DONE;
                        end
                        else begin
                            bit_cnt <= bit_cnt + 1'b1;
                            rx_state <= RECEIVE;
                        end
                    end
                    else begin
                        sample_cnt <= sample_cnt + 1'b1;
                    end
                end
                else begin
                    sample_cnt <= sample_cnt;
                end
            end
            DONE:begin
                if (rx_clk) begin
                    if (sample_cnt == 4'd7) begin
                        sample_cnt <= sample_cnt + 1'b1;
                        rx_err <= !rx_syn;
                    end
                    else if (sample_cnt == 4'd15) begin
                        rx_state <= IDLE;
                        sample_cnt <= 4'd0;
                        if (rx_err) begin
                            rx_done <= 1'b0;
                        end
                        else begin
                            rx_data <= rx_data_buf;
                            rx_done <= 1'b1;
                        end
                    end
                    else begin
                        sample_cnt <= sample_cnt + 1'b1;
                    end
                end
                else begin
                    sample_cnt <= sample_cnt;
                end
            end
        endcase
    end
    end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        rx_cnt <= 9'b0;
    end
    else if (rx_state != IDLE) begin
        if (rx_cnt == RX_BAUD_CNT - 1'b1) begin
            rx_cnt <= 9'b0;
            rx_clk <= 1'b1;
        end
        else begin
            rx_cnt <= rx_cnt + 1'b1;
            rx_clk <= 1'b0;
        end
    end
    else begin
        rx_clk <= 1'b0;
        rx_cnt <= 9'b0;
    end
end

endmodule