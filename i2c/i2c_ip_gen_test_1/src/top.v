module top(
    input  wire clk_27m,
    input  wire rst_n,
    inout  wire SCL,
    inout  wire SDA
);

wire       iic_int;
wire [7:0] rdata;
reg        tx_en;
reg  [2:0] waddr;
reg  [7:0] wdata;
reg        rx_en;
reg  [2:0] raddr;

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

localparam [5:0]
    ST_IDLE            = 6'd0,
    ST_PRESCALE_L      = 6'd1,
    ST_PRESCALE_H      = 6'd2,
    ST_CTRL_EN         = 6'd3,

    ST_TX_78           = 6'd4,
    ST_CMD_STA_WR      = 6'd5,
    ST_POLL1H_REQ      = 6'd6,
    ST_POLL1H_WAIT     = 6'd7,
    ST_POLL1H_CHECK    = 6'd8,
    ST_POLL1L_REQ      = 6'd9,
    ST_POLL1L_WAIT     = 6'd10,
    ST_POLL1L_CHECK    = 6'd11,

    ST_TX_00           = 6'd12,
    ST_CMD_WR_00       = 6'd13,
    ST_POLL2H_REQ      = 6'd14,
    ST_POLL2H_WAIT     = 6'd15,
    ST_POLL2H_CHECK    = 6'd16,
    ST_POLL2L_REQ      = 6'd17,
    ST_POLL2L_WAIT     = 6'd18,
    ST_POLL2L_CHECK    = 6'd19,

    ST_TX_AE           = 6'd20,
    ST_CMD_WR_STO      = 6'd21,
    ST_POLL3H_REQ      = 6'd22,
    ST_POLL3H_WAIT     = 6'd23,
    ST_POLL3H_CHECK    = 6'd24,
    ST_POLL3L_REQ      = 6'd25,
    ST_POLL3L_WAIT     = 6'd26,
    ST_POLL3L_CHECK    = 6'd27,

    ST_GAP             = 6'd28;

reg [5:0] st;
reg [7:0] step_wait;
reg [23:0] gap_cnt;

localparam [7:0]  STEP_WAIT_MAX = 8'd8;       // short bus-spacing delay
localparam [23:0] GAP_MAX       = 24'd270000; // about 10ms @27MHz

always @(posedge clk_27m or negedge rst_n) begin
    if (!rst_n) begin
        st       <= ST_IDLE;
        tx_en    <= 1'b0;
        waddr    <= 3'd0;
        wdata    <= 8'd0;
        rx_en    <= 1'b0;
        raddr    <= 3'd0;
        step_wait<= 8'd0;
        gap_cnt  <= 24'd0;
    end else begin
        tx_en <= 1'b0;
        rx_en <= 1'b0;

        if (step_wait != 8'd0)
            step_wait <= step_wait - 8'd1;

        case (st)
            ST_IDLE: begin
                st <= ST_PRESCALE_L;
            end

            ST_PRESCALE_L: begin
                tx_en <= 1'b1; waddr <= 3'd0; wdata <= 8'd53;
                step_wait <= STEP_WAIT_MAX;
                st <= ST_PRESCALE_H;
            end

            ST_PRESCALE_H: begin
                if (step_wait == 8'd0) begin
                    tx_en <= 1'b1; waddr <= 3'd1; wdata <= 8'd0;
                    step_wait <= STEP_WAIT_MAX;
                    st <= ST_CTRL_EN;
                end
            end

            ST_CTRL_EN: begin
                if (step_wait == 8'd0) begin
                    tx_en <= 1'b1; waddr <= 3'd2; wdata <= 8'h80; // core enable
                    step_wait <= STEP_WAIT_MAX;
                    st <= ST_TX_78;
                end
            end

            ST_TX_78: begin
                if (step_wait == 8'd0) begin
                    tx_en <= 1'b1; waddr <= 3'd3; wdata <= 8'h78;
                    step_wait <= STEP_WAIT_MAX;
                    st <= ST_CMD_STA_WR;
                end
            end

            ST_CMD_STA_WR: begin
                if (step_wait == 8'd0) begin
                    tx_en <= 1'b1; waddr <= 3'd4; wdata <= 8'h90; // STA + WR
                    st <= ST_POLL1H_REQ;
                end
            end

            ST_POLL1H_REQ: begin
                rx_en <= 1'b1; raddr <= 3'd4; // read SR
                st <= ST_POLL1H_WAIT;
            end
            ST_POLL1H_WAIT: begin
                st <= ST_POLL1H_CHECK;
            end
            ST_POLL1H_CHECK: begin
                if (rdata[1] == 1'b1) begin // wait TIP=1 first
                    st <= ST_POLL1L_REQ;
                end else begin
                    st <= ST_POLL1H_REQ;
                end
            end
            ST_POLL1L_REQ: begin
                rx_en <= 1'b1; raddr <= 3'd4;
                st <= ST_POLL1L_WAIT;
            end
            ST_POLL1L_WAIT: begin
                st <= ST_POLL1L_CHECK;
            end
            ST_POLL1L_CHECK: begin
                if (rdata[1] == 1'b0) begin // then wait TIP=0
                    st <= ST_TX_00;
                end else begin
                    st <= ST_POLL1L_REQ;
                end
            end

            ST_TX_00: begin
                tx_en <= 1'b1; waddr <= 3'd3; wdata <= 8'h00;
                step_wait <= STEP_WAIT_MAX;
                st <= ST_CMD_WR_00;
            end

            ST_CMD_WR_00: begin
                if (step_wait == 8'd0) begin
                    tx_en <= 1'b1; waddr <= 3'd4; wdata <= 8'h10; // WR
                    st <= ST_POLL2H_REQ;
                end
            end

            ST_POLL2H_REQ: begin
                rx_en <= 1'b1; raddr <= 3'd4;
                st <= ST_POLL2H_WAIT;
            end
            ST_POLL2H_WAIT: begin
                st <= ST_POLL2H_CHECK;
            end
            ST_POLL2H_CHECK: begin
                if (rdata[1] == 1'b1) begin
                    st <= ST_POLL2L_REQ;
                end else begin
                    st <= ST_POLL2H_REQ;
                end
            end
            ST_POLL2L_REQ: begin
                rx_en <= 1'b1; raddr <= 3'd4;
                st <= ST_POLL2L_WAIT;
            end
            ST_POLL2L_WAIT: begin
                st <= ST_POLL2L_CHECK;
            end
            ST_POLL2L_CHECK: begin
                if (rdata[1] == 1'b0) begin
                    st <= ST_TX_AE;
                end else begin
                    st <= ST_POLL2L_REQ;
                end
            end

            ST_TX_AE: begin
                tx_en <= 1'b1; waddr <= 3'd3; wdata <= 8'hAE;
                step_wait <= STEP_WAIT_MAX;
                st <= ST_CMD_WR_STO;
            end

            ST_CMD_WR_STO: begin
                if (step_wait == 8'd0) begin
                    tx_en <= 1'b1; waddr <= 3'd4; wdata <= 8'h50; // WR + STO
                    st <= ST_POLL3H_REQ;
                end
            end

            ST_POLL3H_REQ: begin
                rx_en <= 1'b1; raddr <= 3'd4;
                st <= ST_POLL3H_WAIT;
            end
            ST_POLL3H_WAIT: begin
                st <= ST_POLL3H_CHECK;
            end
            ST_POLL3H_CHECK: begin
                if (rdata[1] == 1'b1) begin
                    st <= ST_POLL3L_REQ;
                end else begin
                    st <= ST_POLL3H_REQ;
                end
            end
            ST_POLL3L_REQ: begin
                rx_en <= 1'b1; raddr <= 3'd4;
                st <= ST_POLL3L_WAIT;
            end
            ST_POLL3L_WAIT: begin
                st <= ST_POLL3L_CHECK;
            end
            ST_POLL3L_CHECK: begin
                if (rdata[1] == 1'b0) begin
                    gap_cnt <= 24'd0;
                    st <= ST_GAP;
                end else begin
                    st <= ST_POLL3L_REQ;
                end
            end

            ST_GAP: begin
                if (gap_cnt >= GAP_MAX) begin
                    st <= ST_TX_78;
                end else begin
                    gap_cnt <= gap_cnt + 24'd1;
                end
            end

            default: begin
                st <= ST_IDLE;
            end
        endcase
    end
end

endmodule
