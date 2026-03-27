module ze08_ch2o_data(
    input sys_clk,
    input sys_rst_n,

    input rx,
    output reg data_ready
);

parameter HEAD_VAILD_1     = 8'b0000_0001;
parameter HEAD_VAILD_2     = 8'b0000_0010;
parameter HEAD_VAILD_3     = 8'b0000_0100;
parameter HEAD_VAILD_4     = 8'b0000_1000;
parameter RECEIVE_DATA     = 8'b0001_0000;
parameter RECEIVE_TAIL     = 8'b0010_0000;
parameter RECEIVE_CHECKSUM = 8'b0100_0000;

parameter HEAD_1 = 8'hff;
parameter HEAD_2 = 8'h17;
parameter HEAD_3 = 8'h04;
parameter HEAD_4 = 8'h00;

//uart_rx
wire rx_done;
wire rx_err;
wire [7:0] rx_data;

reg [7:0] state;
reg [15:0] CH2O_data;
reg [1:0] bit_cnt;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        state <= HEAD_VAILD_1;
        CH2O_data <= {16{1'b1}};
        data_ready <= 1'b0;
        bit_cnt <= 2'b00;
    end
    else begin
        case (state)
            HEAD_VAILD_1:begin
                data_ready <= 1'b0;
                CH2O_data <= {16{1'b1}};
                bit_cnt <= 2'b00;
                state <= (rx_done && rx_data == HEAD_1) ? HEAD_VAILD_2 : HEAD_VAILD_1;
            end
            HEAD_VAILD_2:begin
                state <= (rx_done && rx_data == HEAD_2) ? HEAD_VAILD_3 : HEAD_VAILD_2;
            end
            HEAD_VAILD_3:begin
                state <= (rx_done && rx_data == HEAD_3) ? HEAD_VAILD_4 : HEAD_VAILD_3;
            end
            HEAD_VAILD_4:begin
                state <= (rx_done && rx_data == HEAD_4) ? RECEIVE_DATA : HEAD_VAILD_4;
            end
            RECEIVE_DATA:begin
                if (rx_done) begin
                    if (bit_cnt == 2'd2) begin
                        state <= RECEIVE_TAIL;
                        bit_cnt <= 2'd0;
                    end
                    else begin
                        CH2O_data <= {CH2O_data[7:0], rx_data};
                        bit_cnt <= bit_cnt + 1'b1;
                    end
                end
                else begin
                    bit_cnt <= bit_cnt;
                end
            end
            RECEIVE_TAIL:begin
                if (rx_done) begin
                    state <= (bit_cnt == 2'd2) ? RECEIVE_CHECKSUM : RECEIVE_TAIL;
                    bit_cnt <= (bit_cnt == 2'd2) ? 2'd0 : bit_cnt + 1'b1;
                end
                else begin
                    bit_cnt <= bit_cnt;
                end
            end
            RECEIVE_CHECKSUM:begin
                state <= (rx_done) ? HEAD_VAILD_1 : RECEIVE_CHECKSUM;
                data_ready <= (rx_done) ? 1'b1 : 1'b0;
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