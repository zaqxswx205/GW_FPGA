module i2c_driver(
    input sys_clk,
    input sys_rst_n,

    input  en,
    input  INIT,
    input  command_data,
    input  [7:0] payload_len,
    input  [63:0] data,
    output reg done,
    output reg busy,
    inout SCL,
    inout SDA
);

localparam RADDR = 3'd4;
localparam PRESCALE_LOW_BYTE = 8'd53;
localparam PRESCALE_LOW_ADDR = 3'd0;
localparam PRESCALE_HIGH_BYTE = 8'd0;
localparam PRESCALE_HIGH_ADDR = 3'd1;
localparam CTRL_EN_BYTE = 8'h80;
localparam CTRL_EN_ADDR = 3'd2;
localparam TRANSMIT_ADDR = 3'd3;
localparam COMMAND_ADDR = 3'd4;
localparam START_AND_SEND = 8'h90;
localparam SEND_EN_BYTE = 8'h10;
localparam STOP_AND_SEND_BYTE = 8'h50;

localparam I2C_DEVICE_ADDR = 8'h78;
// localparam COMMAND_PRE = 8'h00;
// localparam DATA_PRE = 8'h40;

localparam [8:0]
    IDLE         = 9'b0_0000_0001,
    PRESCALE_L   = 9'b0_0000_0010,
    PRESCALE_H   = 9'b0_0000_0100,
    CTRL_EN      = 9'b0_0000_1000,
    START        = 9'b0_0001_0000,
    COMMAND_DATA = 9'b0_0010_0000,
    SEND         = 9'b0_0100_0000,
    STOP         = 9'b0_1000_0000,
    DONE         = 9'b1_0000_0000;

//i2c_Master
wire       iic_int;
wire [7:0] rdata;
reg        tx_en;
reg  [2:0] waddr;
reg  [7:0] wdata;
wire        rx_en;

//i2c_wait_tip
reg start;
wire wait_done;
wire wait_busy;
wire ack_error;
reg  error_nack;

reg [8:0] cur_state;
reg [8:0] next_state;
reg [1:0] hold_cnt;
reg [7:0] byte_cnt;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) cur_state <= IDLE;
    else cur_state <= next_state;
end

always @(*) begin
    case (cur_state)
        IDLE: begin
            if (en) next_state = (INIT) ? PRESCALE_L : START;
            else next_state = IDLE;
        end
        PRESCALE_L: next_state = (hold_cnt == 2'b11) ? PRESCALE_H : PRESCALE_L;
        PRESCALE_H: next_state = (hold_cnt == 2'b11) ? CTRL_EN : PRESCALE_H;
        CTRL_EN   : next_state = (hold_cnt == 2'b11) ? DONE : CTRL_EN;
        START     : next_state = (wait_done) ? COMMAND_DATA : START;
        COMMAND_DATA: begin
            if (wait_done)next_state = (payload_len == 8'd1) ? STOP : SEND;  
            else next_state = COMMAND_DATA;
        end    
        SEND: next_state = (byte_cnt == 8'd1) ? STOP : SEND;
        STOP: next_state = (wait_done) ? DONE : STOP;
        DONE: next_state = IDLE;
        default: next_state = IDLE;
    endcase
end


always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        tx_en <= 1'b0;
        waddr <= 3'd0;
        wdata <= 8'd0;
        start <= 1'b0;
        hold_cnt <= 2'd0;
        error_nack <= 1'b0;
        done <= 1'b0;
        busy <= 1'b0;
        byte_cnt <= 8'd0;
    end
    else begin
        tx_en <= 1'b0;
        start <= 1'b0;
        done <= 1'b0;
        case (cur_state)
            IDLE:begin
                tx_en <= 1'b0;
                waddr <= 3'd0;
                wdata <= 8'd0;
                start <= 1'b0;
                hold_cnt <= 2'd0;
                error_nack <= 1'b0;
                done <= 1'b0;
                busy <= 1'b0;
                byte_cnt <= 8'd0;
            end
            PRESCALE_L:begin
                busy <= 1'b1;
                tx_en <= 1'b1;
                waddr <= PRESCALE_LOW_ADDR;
                wdata <= PRESCALE_LOW_BYTE;
                hold_cnt <= hold_cnt + 1'b1;
            end
            PRESCALE_H:begin
                tx_en <= 1'b1;
                waddr <= PRESCALE_HIGH_ADDR;
                wdata <= PRESCALE_HIGH_BYTE;
                hold_cnt <= hold_cnt + 1'b1;
            end
            CTRL_EN:begin
                tx_en <= 1'b1;
                waddr <= CTRL_EN_ADDR;
                wdata <= CTRL_EN_BYTE;
                hold_cnt <= hold_cnt + 1'b1;
            end
            START:begin
                byte_cnt <= payload_len;
                busy <= 1'b1;
                if (hold_cnt == 2'b00) begin
                    tx_en <= 1'b1;
                    waddr <= TRANSMIT_ADDR;
                    wdata <= I2C_DEVICE_ADDR;
                    hold_cnt <= hold_cnt + 1'b1;
                end
                else if (hold_cnt == 2'b01)begin
                    tx_en <= 1'b1;
                    waddr <= COMMAND_ADDR;
                    wdata <= START_AND_SEND;
                    hold_cnt <= hold_cnt + 1'b1;
                end
                else begin
                    start <= 1'b1;
                    hold_cnt <= (wait_done) ? 2'd0 : hold_cnt;
                end
            end
            COMMAND_DATA:begin
                if (hold_cnt == 2'b00) begin
                    tx_en <= 1'b1;
                    waddr <= TRANSMIT_ADDR;
                    // wdata <= (command_data) ? DATA_PRE : COMMAND_PRE;
                    wdata <= {1'b0,command_data,6'b00_0000};
                    hold_cnt <= hold_cnt + 1'b1;
                end
                else if (hold_cnt == 2'b01)begin
                    tx_en <= 1'b1;
                    waddr <= COMMAND_ADDR;
                    wdata <= SEND_EN_BYTE;
                    hold_cnt <= hold_cnt + 1'b1;
                end
                else begin
                    start <= 1'b1;
                    hold_cnt <= (wait_done) ? 2'd0 : hold_cnt;
                end
            end
            SEND:begin
                if (hold_cnt == 2'b00) begin
                    tx_en <= 1'b1;
                    waddr <= TRANSMIT_ADDR;
                    wdata <= data >> ((byte_cnt-1)*8);
                    hold_cnt <= hold_cnt + 1'b1;
                end
                else if (hold_cnt == 2'b01)begin
                    tx_en <= 1'b1;
                    waddr <= COMMAND_ADDR;
                    wdata <= SEND_EN_BYTE;
                    hold_cnt <= hold_cnt + 1'b1;
                end
                else begin
                    start <= 1'b1;
                    hold_cnt <= (wait_done) ? 2'd0 : hold_cnt;
                    byte_cnt <= (wait_done) ? byte_cnt - 1'b1 : byte_cnt;
                end
            end
            STOP:begin
                if (hold_cnt == 2'b00) begin
                    tx_en <= 1'b1;
                    waddr <= TRANSMIT_ADDR;
                    wdata <= data[7:0];
                    hold_cnt <= hold_cnt + 1'b1;
                end
                else if (hold_cnt == 2'b01)begin
                    tx_en <= 1'b1;
                    waddr <= COMMAND_ADDR;
                    wdata <= STOP_AND_SEND_BYTE;    
                    hold_cnt <= hold_cnt + 1'b1;
                end
                else begin
                    start <= 1'b1;
                    hold_cnt <= (wait_done) ? 2'd0 : hold_cnt;
                end
            end
            DONE:begin
                error_nack <= ack_error;
                done <= 1'b1;
                busy <= 1'b0;
            end
            default:begin
                tx_en <= 1'b0;
                waddr <= 3'd0;
                wdata <= 8'd0;
                start <= 1'b0;
                done <= 1'b0;
                error_nack <= 1'b0;
            end
        endcase
    end
end

i2c_wait_tip u_i2c_wait_tip(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .start(start),
    .rdata(rdata),
    .rx_en(rx_en),
    .busy(wait_busy),
    .done(wait_done),
    .ack_error(ack_error)
);

I2C_MASTER_Top u_i2c (
    .I_CLK     (sys_clk),
    .I_RESETN  (sys_rst_n),
    .I_TX_EN   (tx_en),
    .I_WADDR   (waddr),
    .I_WDATA   (wdata),
    .I_RX_EN   (rx_en),
    .I_RADDR   (RADDR),
    .O_RDATA   (rdata),
    .O_IIC_INT (iic_int),
    .SCL       (SCL),
    .SDA       (SDA)
);
endmodule
