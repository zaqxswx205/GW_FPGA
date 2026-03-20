module top (
    input sys_clk,
    input sys_rst_n,

    input rx,
    output tx
);

parameter IDLE = 4'b0001;
parameter SEND_MODE = 4'b0010;
parameter REQUEST_DATA = 4'b0100;
parameter RECEIVE_DATA = 4'b1000;

wire tx_clk;
wire data_set;
wire send_set;
wire rx_clk;
wire send_done;

reg data_set_buf;
reg send_set_buf;
reg [3:0] state;

assign data_set = data_set_buf;
assign send_set = send_set_buf;
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        state <= IDLE;
    end
    else begin
        send_set_buf <= 1'b0;
        case (state)
            IDLE:begin
                state <= SEND_MODE;
            end
            SEND_MODE:begin
                send_set_buf <= 1'b1;
                data_set_buf <= 1'b1;
                state <= (send_done) ? REQUEST_DATA : SEND_MODE;
            end
            REQUEST_DATA:begin
                send_set_buf <= 1'b1;
                data_set_buf <= 1'b0;
                state <= (send_done) ? RECEIVE_DATA : REQUEST_DATA;
            end
            RECEIVE_DATA:begin
                state <= IDLE;
            end
            default:begin
                state <= IDLE;
            end
        endcase
    end
end

// reg can_send_d;
// always @(posedge sys_clk or negedge sys_rst_n) begin
//     if (!sys_rst_n)  can_send_d <= 1'b0;
//     else             can_send_d <= !tx_busy && !empty;
// end
// assign tx_set = (!tx_busy && !empty) && !can_send_d;  // 上升沿单拍
// assign rd_en  = tx_set;

mulit_tx_top u_mulit_tx_top(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),

    .tx_clk(tx_clk),
    .data_set(data_set),
    .send_set(send_set),
    .send_done(send_done),
    .tx(tx)
);

// uart_rx u_uart_rx(
//     .sys_clk(sys_clk),
//     .sys_rst_n(sys_rst_n),

//     .rx_clk(rx_clk),
//     .rx(rx),
//     .rx_done(rx_done),
//     .rx_err(rx_err),
//     .rx_data(rx_data)
// );

baud_gen u_baud_gen(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .tx_clk(tx_clk),
    .rx_clk(rx_clk)
);



endmodule