module ze08_ch2o_data(
    input sys_clk,
    input sys_rst_n,

    input rx,
    output reg data_ready,
    output reg [15:0] ch2o_data
);

parameter HEAD_VAILD_1     = 9'b0_0000_0001;
parameter HEAD_VAILD_2     = 9'b0_0000_0010;
parameter HEAD_VAILD_3     = 9'b0_0000_0100;
parameter HEAD_VAILD_4     = 9'b0_0000_1000;
parameter RECEIVE_HIGH     = 9'b0_0001_0000;
parameter RECEIVE_LOW      = 9'b0_0010_0000;
parameter RECEIVE_RANGE_H  = 9'b0_0100_0000;
parameter RECEIVE_RANGE_L  = 9'b0_1000_0000;
parameter RECEIVE_CHECKSUM = 9'b1_0000_0000;

parameter HEAD_1 = 8'hff;
parameter HEAD_2 = 8'h17;
parameter HEAD_3 = 8'h04;
parameter HEAD_4 = 8'h00;

//uart_rx
wire rx_done;
wire rx_err;
wire [7:0] rx_data;

reg [8:0] state;
reg [15:0] ch2o_data_buf;
reg [7:0] checksum_sum;
wire [7:0] checksum_calc = ~checksum_sum + 8'd1;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        state <= HEAD_VAILD_1;
        ch2o_data_buf <= {16{1'b1}};
        ch2o_data <= 16'd0;
        data_ready <= 1'b0;
        checksum_sum <= 8'd0;
    end
    else begin
        case (state)
            HEAD_VAILD_1:begin
                data_ready <= 1'b0;
                ch2o_data_buf <= {16{1'b1}};
                checksum_sum <= 8'd0;
                state <= (rx_done && rx_data == HEAD_1) ? HEAD_VAILD_2 : HEAD_VAILD_1;
            end
            HEAD_VAILD_2:begin
                if (rx_done && rx_data == HEAD_2)
                    checksum_sum <= HEAD_2;
                state <= (rx_done && rx_data == HEAD_2) ? HEAD_VAILD_3 : HEAD_VAILD_2;
            end
            HEAD_VAILD_3:begin
                if (rx_done && rx_data == HEAD_3)
                    checksum_sum <= checksum_sum + HEAD_3;
                state <= (rx_done && rx_data == HEAD_3) ? HEAD_VAILD_4 : HEAD_VAILD_3;
            end
            HEAD_VAILD_4:begin
                if (rx_done && rx_data == HEAD_4)
                    checksum_sum <= checksum_sum + HEAD_4;
                state <= (rx_done && rx_data == HEAD_4) ? RECEIVE_HIGH : HEAD_VAILD_4;
            end
            RECEIVE_HIGH:begin
                if (rx_done) begin
                    ch2o_data_buf[15:8] <= rx_data;
                    checksum_sum <= checksum_sum + rx_data;
                    state <= RECEIVE_LOW;
                end
            end
            RECEIVE_LOW:begin
                if (rx_done) begin
                    ch2o_data_buf[7:0] <= rx_data;
                    checksum_sum <= checksum_sum + rx_data;
                    state <= RECEIVE_RANGE_H;
                end
            end
            RECEIVE_RANGE_H:begin
                if (rx_done) begin
                    checksum_sum <= checksum_sum + rx_data;
                    state <= RECEIVE_RANGE_L;
                end
            end
            RECEIVE_RANGE_L:begin
                if (rx_done) begin
                    checksum_sum <= checksum_sum + rx_data;
                    state <= RECEIVE_CHECKSUM;
                end
            end
            RECEIVE_CHECKSUM:begin
                state <= (rx_done) ? HEAD_VAILD_1 : RECEIVE_CHECKSUM;
                data_ready <= (rx_done && rx_data == checksum_calc) ? 1'b1 : 1'b0;
                if (rx_done && rx_data == checksum_calc)
                    ch2o_data <= ch2o_data_buf;
            end
            default:begin
                state <= HEAD_VAILD_1;
            end
        endcase
    end
end


uart_rx u_uart_rx(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),

    .rx(rx),

    .rx_done(rx_done),
    .rx_err(rx_err),
    .rx_data(rx_data)
);
endmodule
