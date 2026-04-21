module top(
    input sys_clk,
    input sys_rst_n,

    inout SCL,
    inout SDA
);

localparam [6:0]
    IDLE       = 7'b000_0001,
    PRESCALE_L = 7'b000_0010,
    PRESCALE_H = 7'b000_0100,
    CTRL_EN    = 7'b000_1000,
    START      = 7'b001_0000,
    SEND       = 7'b010_0000,
    STOP       = 7'b100_0000,

//i2c_Master
wire       iic_int;
wire [7:0] rdata;
reg        tx_en;
reg  [2:0] waddr;
reg  [7:0] wdata;
reg        rx_en;
reg  [2:0] raddr;

reg [6:0] cur_state;
reg [6:0] next_state;
reg state_done;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        cur_state <= IDLE;
    end
    else begin
        cur_state <= next_state;
    end
end

always @(*) begin
    case (cur_state)
        IDLE: next_state = PRESCALE_L;
        PRESCALE_L: next_state = PRESCALE_H;
        PRESCALE_H: next_state = CTRL_EN;
        CTRL_EN: next_state = START;
        START: next_state = SEND;
        SEND: next_state = STOP;
        STOP: next_state = IDLE;
        default: next_state = IDLE;
    endcase
end


always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        tx_en <= 1'b0;
        waddr <= 3'd0;
        wdata <= 8'd0;
        state_done <= 1'b0;
    end
    else begin
        state_done <= 1'b0;
        case (cur_state)
            IDLE:begin
                tx_en <= 1'b0;
                waddr <= 3'd0;
                wdata <= 8'd0;
                state_done <= 1'b0;
            end
            PRESCALE_L:begin
                tx_en <= 1'b1;
                waddr <= 3'd0;
                wdata <= 8'd53;
                state_done <= 1'b1;
            end
            PRESCALE_H:begin
                tx_en <= 1'b1;
                waddr <= 3'd1;
                wdata <= 8'd0;
                state_done <= 1'b1;
            end
            CTRL_EN:begin
                tx_en <= 1'b1;
                waddr <= 3'd2;
                wdata <= 8'h80;
                state_done <= 1'b1;
            end
            START:begin
                tx_en <= 1'b1;
                waddr <= 3'd4;
                wdata <= 8'h80;
            end
        endcase
    end
end


I2C_MASTER_Top u_i2c (
    .I_CLK     (clk_27m),
    .I_RESETN  (rst_n),
    .I_TX_EN   (tx_en),
    .I_WADDR   (waddr),
    .I_WDATA   (wdata),
    .I_RX_EN   (rx_en),
    .I_RADDR   (raddr),
    .O_RDATA   (rdata),
    .O_IIC_INT (iic_int),
    .SCL       (SCL),
    .SDA       (SDA)
);
endmodule