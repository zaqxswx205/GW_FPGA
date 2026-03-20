module mulit_tx_top(
    input sys_clk,
    input sys_rst_n,

    input tx_clk,
    input data_set,
    input send_set,
    output reg send_done,
    output tx
);

parameter [47:0] DATA_SET_1 = {8'h42, 8'h4d, 8'hE1, 8'h00, 8'h00, 8'h20};
parameter [47:0] DATA_SET_2 = {8'h42, 8'h4d, 8'hE2, 8'h00, 8'h00, 8'h71};

parameter IDLE = 9'b00_000_0001;
parameter BYTE_1 = 9'b00_000_0010;//42
parameter BYTE_2 = 9'b00_000_0100;//4d
parameter BYTE_3 = 9'b00_000_1000;//e1
parameter BYTE_4 = 9'b00_001_0000;//00
parameter BYTE_5 = 9'b00_010_0000;//00
parameter BYTE_6 = 9'b00_100_0000;//20

//uart_tx
wire tx_set;
wire [7:0] tx_data;
wire tx_done;
wire tx_busy;

reg [8:0] send_state;

reg [7:0] tx_data_buf;
reg tx_set_buf;
reg [47:0] data_set_buf;

wire send_set_buf;
reg send_set_d;
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)  send_set_d <= 1'b0;
    else             send_set_d <= send_set;
end
assign send_set_buf = send_set && !send_set_d;  // 上升沿单拍

assign tx_data = tx_data_buf;
assign tx_set = tx_set_buf;
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        send_state <= IDLE;
        send_done <= 1'b0;
    end
    else begin
        case (send_state)
            IDLE:begin
                send_done <= 1'b0;
                data_set_buf <= (data_set) ? DATA_SET_1 : DATA_SET_2;
                send_state <= (send_set_buf) ? BYTE_1 : IDLE;
            end
            BYTE_1:begin
                if (!tx_busy && !tx_done) begin
                    tx_set_buf <= 1'b1;
                    tx_data_buf <= data_set_buf[47:40];
                end
                else begin
                    tx_set_buf <= 1'b0;
                end
                send_state <= (tx_done) ? BYTE_2 : BYTE_1;
            end
            BYTE_2:begin
                if (!tx_busy && !tx_done) begin
                    tx_set_buf <= 1'b1;
                    tx_data_buf <= data_set_buf[39:32];
                end
                else begin
                    tx_set_buf <= 1'b0;
                end
                send_state <= (tx_done) ? BYTE_3: BYTE_2;
            end
            BYTE_3:begin
                if (!tx_busy && !tx_done) begin
                    tx_set_buf <= 1'b1;
                    tx_data_buf <= data_set_buf[31:24];
                end
                else begin
                    tx_set_buf <= 1'b0;
                end
                send_state <= (tx_done) ? BYTE_4: BYTE_3;
            end
            BYTE_4:begin
                if (!tx_busy && !tx_done) begin
                    tx_set_buf <= 1'b1;
                    tx_data_buf <= data_set_buf[23:16];
                end
                else begin
                    tx_set_buf <= 1'b0;
                end
                send_state <= (tx_done) ? BYTE_5: BYTE_4;
            end
            BYTE_5:begin
                if (!tx_busy && !tx_done) begin
                    tx_set_buf <= 1'b1;
                    tx_data_buf <= data_set_buf[15:8];
                end
                else begin
                    tx_set_buf <= 1'b0;
                end
                send_state <= (tx_done) ? BYTE_6: BYTE_5;
            end
            BYTE_6:begin
                if (!tx_busy && !tx_done) begin
                    tx_set_buf <= 1'b1;
                    tx_data_buf <= data_set_buf[7:0];
                end
                else begin
                    tx_set_buf <= 1'b0;
                end
                send_state <= (tx_done) ? IDLE: BYTE_6;
                send_done <= 1'b1;
            end
            default:begin
                send_state <= IDLE;
            end
        endcase
    end
end

uart_tx u_uart_tx(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),

    .tx_clk(tx_clk),
    .tx_set(tx_set),
    .tx_data(tx_data),
    .tx_done(tx_done),
    .tx_busy(tx_busy),
    .tx(tx)
);

endmodule