module uart_rx(
    input sys_clk,
    input sys_rst_n,

    input rx_clk,
    input rx,

    output reg rx_done,
    output reg rx_err,

    output reg [7:0] rx_data
);

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
        rx_state <= 4'b0001;
        rx_done <= 1'b0;
        rx_err <= 1'b0;
        bit_cnt <= 4'd0;
        sample_cnt <= 4'd0;
    end
    else if (rx_clk) begin
        case (rx_state)
            4'b0001:begin
                rx_done <= 1'b0;
                bit_cnt <= 4'd0;
                sample_cnt <= 4'd0;
                rx_err <= 1'b0;
                rx_state <= (rx_syn) ? 4'b0001 : 4'b0010;
            end
            4'b0010:begin
                if (sample_cnt == 4'd7) begin
                    sample_cnt <= sample_cnt + 1'b1;
                    rx_err <= rx_syn;
                end
                else if (sample_cnt == 4'd15) begin
                    rx_state <= (rx_err) ? 4'b0001 : 4'b0100;
                    sample_cnt <= 4'd0;
                end
                else begin
                    sample_cnt <= sample_cnt + 1'b1;
                end
            end
            4'b0100:begin
                if (sample_cnt == 4'd7) begin
                    rx_data_buf <= {rx_syn, rx_data_buf[7:1]};
                    sample_cnt <= sample_cnt + 1'b1;
                end
                else if (sample_cnt == 4'd15) begin
                    sample_cnt <= 4'd0;
                    if (bit_cnt == 4'd7) begin
                        bit_cnt <= 4'd0;
                        rx_state <= 4'b1000;
                    end
                    else begin
                        bit_cnt <= bit_cnt + 1'b1;
                        rx_state <= 4'b0100;
                    end
                end
                else begin
                    sample_cnt <= sample_cnt + 1'b1;
                end
            end
            4'b1000:begin
                if (sample_cnt == 4'd7) begin
                    sample_cnt <= sample_cnt + 1'b1;
                    rx_err <= !rx_syn;
                end
                else if (sample_cnt == 4'd15) begin
                    rx_state <= 4'b0001;
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
        endcase
    end
    else begin
        rx_state <= rx_state;
        rx_done <= 1'b0;
        rx_err <= rx_err;
        bit_cnt <= bit_cnt;
        sample_cnt <= sample_cnt;
    end
    end


endmodule