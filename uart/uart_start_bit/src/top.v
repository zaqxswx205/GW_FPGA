module top(
    input sys_clk,
    input sys_rst_n,

    input rx,
    output tx
);
//42 4D 00 1C 00 05 00 08 00 0A 00 05 00 08 00 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 3A
parameter HEAD_VAILD_1 = 6'b00_0001;//42
parameter HEAD_VAILD_2 = 6'b00_0010;//4D  
parameter HEAD_VAILD_3 = 6'b00_0100;//00
parameter HEAD_VAILD_4 = 6'b00_1000;//1C
parameter RECEIVE_DATA = 6'b01_0000;
parameter SEND_DATA    = 6'b10_0000;

parameter HEAD_1 = 8'h42;
parameter HEAD_2 = 8'h4D;
parameter HEAD_3 = 8'h00;
parameter HEAD_4 = 8'h1C;

//uart_rx
wire rx_clk;
wire rx_done;
wire rx_err;
wire [7:0] rx_data;

//uart_tx
wire tx_clk;
wire tx_set;
wire tx_done;
wire tx_busy;

//fifo
wire wr_en;
wire rd_en;
wire        full;
wire        empty;
wire [7:0]  rd_data;

reg [5:0] state;
assign wr_en = rx_done && !full && (state != SEND_DATA);
assign tx_set = !empty && (state == SEND_DATA);
assign rd_en = tx_set && !tx_busy ;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        state <= HEAD_VAILD_1;
    end
    else begin
        case (state)
            HEAD_VAILD_1:begin
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
                state <= (full) ? SEND_DATA : RECEIVE_DATA;
            end
            SEND_DATA:begin
                state <= (empty) ? HEAD_VAILD_1 : SEND_DATA;
            end
            default:begin
                state <= HEAD_VAILD_1;
            end
        endcase
    end
end

uart_tx u_uart_tx(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),

    .tx_clk(tx_clk),
    .tx_set(tx_set),

    .tx(tx),
    .tx_done(tx_done),
    .tx_busy(tx_busy),
    .tx_data(rd_data)
);

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
    .full(full),

    .rd_en(rd_en),
    .rd_data(rd_data),
    .empty(empty)
);
endmodule