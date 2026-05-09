module pms9103_data(
    input sys_clk,
    input sys_rst_n,

    input rx,
    output reg data_ready,
    output reg [15:0] standard_pm1_0,
    output reg [15:0] standard_pm2_5,
    output reg [15:0] standard_pm10,
    output reg [15:0] pm0_3,
    output reg [15:0] pm0_5,
    output reg [15:0] pm1_0
);


//42 4D 00 1C 00 05 00 08 00 0A 00 05 00 08 00 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 3A
parameter HEAD_VAILD_1     = 9'b0_0000_0001;//42
parameter HEAD_VAILD_2     = 9'b0_0000_0010;//4D  
parameter HEAD_VAILD_3     = 9'b0_0000_0100;//00
parameter HEAD_VAILD_4     = 9'b0_0000_1000;//1C
parameter RECEIVE_DATA     = 9'b0_0001_0000;
parameter RECEIVE_VERSION  = 9'b0_0010_0000;//20
parameter RECEIVE_ERROR    = 9'b0_0100_0000;//00
parameter RECEIVE_CHECKSUM = 9'b0_1000_0000;//checksum
parameter SEND_DATA        = 9'b1_0000_0000;

parameter HEAD_1  = 8'h42;
parameter HEAD_2  = 8'h4D;
parameter HEAD_3  = 8'h00;
parameter HEAD_4  = 8'h1C;
parameter VERSION = 8'h20;
parameter ERROR   = 8'h00;

//uart_rx
wire rx_clk;
wire rx_done;
wire rx_err;
wire [7:0] rx_data;

reg [143:0] data_buf;
reg [8:0] state;
reg [7:0] bit_cnt;
reg [15:0] checksum_sum;
reg [7:0] checksum_hi;


always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        state <= HEAD_VAILD_1;
        bit_cnt <= 8'd0;
        data_ready <= 1'b0;
        data_buf <= {144{1'b1}};
        checksum_sum <= 16'd0;
        checksum_hi <= 8'd0;
        standard_pm1_0 <= 16'd0;
        standard_pm2_5 <= 16'd0;
        standard_pm10 <= 16'd0;
        pm0_3 <= 16'd0;
        pm0_5 <= 16'd0;
        pm1_0 <= 16'd0;
    end
    else begin
        case (state)
            HEAD_VAILD_1:begin
                bit_cnt <= 8'd0;
                data_ready <= 1'b0;
                data_buf <= {144{1'b1}};
                checksum_sum <= 16'd0;
                checksum_hi <= 8'd0;
                if (rx_done && rx_data == HEAD_1)
                    checksum_sum <= {8'd0, HEAD_1};
                state <= (rx_done && rx_data == HEAD_1) ? HEAD_VAILD_2 : HEAD_VAILD_1;
            end
            HEAD_VAILD_2:begin
                bit_cnt <= 8'd1;
                if (rx_done && rx_data == HEAD_2)
                    checksum_sum <= checksum_sum + {8'd0, HEAD_2};
                state <= (rx_done && rx_data == HEAD_2) ? HEAD_VAILD_3 : HEAD_VAILD_2;
            end
            HEAD_VAILD_3:begin
                bit_cnt <= 8'd2;
                if (rx_done && rx_data == HEAD_3)
                    checksum_sum <= checksum_sum + {8'd0, HEAD_3};
                state <= (rx_done && rx_data == HEAD_3) ? HEAD_VAILD_4 : HEAD_VAILD_3;
            end
            HEAD_VAILD_4:begin
                bit_cnt <= 8'd3;
                if (rx_done && rx_data == HEAD_4)
                    checksum_sum <= checksum_sum + {8'd0, HEAD_4};
                state <= (rx_done && rx_data == HEAD_4) ? RECEIVE_DATA : HEAD_VAILD_4;
            end
            RECEIVE_DATA:begin
                if (rx_done) begin
                    bit_cnt <= bit_cnt + 1'b1;
                    checksum_sum <= checksum_sum + {8'd0, rx_data};
                    data_buf <= (bit_cnt <= 8'd20) ? {data_buf[135:0], rx_data} : data_buf;
                    state <= (bit_cnt == 8'd26) ? RECEIVE_VERSION : RECEIVE_DATA;
                end
                else begin
                    bit_cnt <= bit_cnt;
                end
            end
            RECEIVE_VERSION:begin
                if (rx_done) begin
                    bit_cnt <= bit_cnt + 1'b1;
                    if (rx_data == VERSION)
                        checksum_sum <= checksum_sum + {8'd0, rx_data};
                    state <= (rx_data == VERSION) ? RECEIVE_ERROR : HEAD_VAILD_1;
                end
                else begin
                    bit_cnt <= bit_cnt;
                end
            end
            RECEIVE_ERROR:begin
                if (rx_done) begin
                    bit_cnt <= bit_cnt + 1'b1;
                    if (rx_data == ERROR)
                        checksum_sum <= checksum_sum + {8'd0, rx_data};
                    state <= (rx_data == ERROR) ? RECEIVE_CHECKSUM : HEAD_VAILD_1;
                end
                else begin
                    bit_cnt <= bit_cnt;
                end
            end
            RECEIVE_CHECKSUM:begin
                if (rx_done)begin
                    if (bit_cnt == 8'd29) begin
                        checksum_hi <= rx_data;
                        bit_cnt <= bit_cnt + 1'b1;
                    end
                    else begin
                        state <= ({checksum_hi, rx_data} == checksum_sum) ? SEND_DATA : HEAD_VAILD_1;
                        bit_cnt <= 8'd0;
                    end
                end
            end
            SEND_DATA:begin
                state <= HEAD_VAILD_1;
                standard_pm1_0 <= data_buf[143:128];
                standard_pm2_5 <= data_buf[127:112];
                standard_pm10  <= data_buf[111:96];
                pm0_3          <= data_buf[47:32];
                pm0_5          <= data_buf[31:16];
                pm1_0          <= data_buf[15:0];
                data_ready <= 1'b1;
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

    .rx_clk(rx_clk),
    .rx(rx),

    .rx_done(rx_done),
    .rx_err(rx_err),
    .rx_data(rx_data)
);
endmodule
