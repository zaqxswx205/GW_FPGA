module sc8_driver (
    input  wire sys_clk,
    input  wire sys_rst_n,

    input  wire rx,
    output reg  data_ready,
    output reg [15:0] co2_data
);

parameter WAIT_HEAD_1 = 3'b001;
parameter WAIT_HEAD_2 = 3'b010;
parameter RECEIVE     = 3'b100;

parameter HEAD_1 = 8'h42;
parameter HEAD_2 = 8'h4D;
parameter CO2_MIN = 16'd400;
parameter CO2_MAX = 16'd5000;

wire rx_done;
wire rx_err;
wire [7:0] rx_data;

reg [2:0] state;
reg [3:0] byte_idx;
reg [7:0] checksum_sum;
reg [15:0] co2_data_buf;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        state <= WAIT_HEAD_1;
        byte_idx <= 4'd0;
        checksum_sum <= 8'd0;
        co2_data_buf <= 16'd0;
        co2_data <= 16'd0;
        data_ready <= 1'b0;
    end else begin
        data_ready <= 1'b0;
        case (state)
            WAIT_HEAD_1: begin
                byte_idx <= 4'd0;
                checksum_sum <= 8'd0;
                if (rx_done && rx_data == HEAD_1) begin
                    checksum_sum <= HEAD_1;
                    state <= WAIT_HEAD_2;
                end
            end

            WAIT_HEAD_2: begin
                if (rx_done) begin
                    if (rx_data == HEAD_2) begin
                        checksum_sum <= checksum_sum + HEAD_2;
                        byte_idx <= 4'd2;
                        state <= RECEIVE;
                    end else begin
                        state <= WAIT_HEAD_1;
                    end
                end
            end

            RECEIVE: begin
                if (rx_done) begin
                    if (byte_idx == 4'd15) begin
                        if ((rx_data == checksum_sum) && (co2_data_buf >= CO2_MIN) && (co2_data_buf <= CO2_MAX)) begin
                            co2_data <= co2_data_buf;
                            data_ready <= 1'b1;
                        end
                        state <= WAIT_HEAD_1;
                        byte_idx <= 4'd0;
                    end else begin
                        checksum_sum <= checksum_sum + rx_data;
                        byte_idx <= byte_idx + 1'b1;
                        if (byte_idx == 4'd6)
                            co2_data_buf[15:8] <= rx_data;
                        else if (byte_idx == 4'd7)
                            co2_data_buf[7:0] <= rx_data;
                    end
                end
            end

            default: begin
                state <= WAIT_HEAD_1;
            end
        endcase
    end
end

uart_rx u_uart_rx (
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .rx(rx),
    .rx_done(rx_done),
    .rx_err(rx_err),
    .rx_data(rx_data)
);

endmodule
