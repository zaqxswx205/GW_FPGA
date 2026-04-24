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

localparam CHECK_SEND = 3'd4;
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

wire iic_int;
wire [7:0] rdata;
wire rx_en;

wire start_wait;
wire wait_done;
wire wait_busy;
wire ack_error;
reg error_nack;

reg [8:0] cur_state;
reg [8:0] next_state;
reg [7:0] byte_cnt;

reg step_start;
wire step_running;
wire step_done;
wire [1:0] step_phase;

reg cfg_op0_tx_valid;
reg [2:0] cfg_op0_waddr;
reg [7:0] cfg_op0_wdata;
reg cfg_op1_tx_valid;
reg [2:0] cfg_op1_waddr;
reg [7:0] cfg_op1_wdata;
reg cfg_op1_mode;
reg [2:0] cfg_op1_raddr;
reg [7:0] cfg_op1_match_data;
reg cfg_use_phase2;
reg cfg_op2_mode;
reg [2:0] cfg_op2_raddr;
reg [7:0] cfg_op2_match_data;

wire tx_en;
wire [2:0] waddr;
wire [7:0] wdata;
wire mode;
wire [2:0] raddr;
wire [7:0] match_data;

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
        PRESCALE_L: next_state = (step_done) ? PRESCALE_H : PRESCALE_L;
        PRESCALE_H: next_state = (step_done) ? CTRL_EN : PRESCALE_H;
        CTRL_EN: next_state = (step_done) ? DONE : CTRL_EN;
        START: next_state = (step_done) ? COMMAND_DATA : START;
        COMMAND_DATA: next_state = (step_done) ? ((payload_len == 8'd1) ? STOP : SEND) : COMMAND_DATA;
        SEND: next_state = (step_done) ? ((byte_cnt == 8'd1) ? STOP : SEND) : SEND;
        STOP: next_state = (step_done) ? DONE : STOP;
        DONE: next_state = IDLE;
        default: next_state = IDLE;
    endcase
end

always @(*) begin
    cfg_op0_tx_valid = 1'b0;
    cfg_op0_waddr = 3'd0;
    cfg_op0_wdata = 8'd0;
    cfg_op1_tx_valid = 1'b0;
    cfg_op1_waddr = 3'd0;
    cfg_op1_wdata = 8'd0;
    cfg_op1_mode = 1'b0;
    cfg_op1_raddr = CHECK_SEND;
    cfg_op1_match_data = 8'd0;
    cfg_use_phase2 = 1'b0;
    cfg_op2_mode = 1'b0;
    cfg_op2_raddr = CHECK_SEND;
    cfg_op2_match_data = 8'd0;

    case (cur_state)
        PRESCALE_L: begin
            cfg_op0_tx_valid = 1'b1;
            cfg_op0_waddr = PRESCALE_LOW_ADDR;
            cfg_op0_wdata = PRESCALE_LOW_BYTE;
            cfg_op1_mode = 1'b0;
            cfg_op1_raddr = PRESCALE_LOW_ADDR;
            cfg_op1_match_data = PRESCALE_LOW_BYTE;
        end
        PRESCALE_H: begin
            cfg_op0_tx_valid = 1'b1;
            cfg_op0_waddr = PRESCALE_HIGH_ADDR;
            cfg_op0_wdata = PRESCALE_HIGH_BYTE;
            cfg_op1_mode = 1'b0;
            cfg_op1_raddr = PRESCALE_HIGH_ADDR;
            cfg_op1_match_data = PRESCALE_HIGH_BYTE;
        end
        CTRL_EN: begin
            cfg_op0_tx_valid = 1'b1;
            cfg_op0_waddr = CTRL_EN_ADDR;
            cfg_op0_wdata = CTRL_EN_BYTE;
            cfg_op1_mode = 1'b0;
            cfg_op1_raddr = CTRL_EN_ADDR;
            cfg_op1_match_data = CTRL_EN_BYTE;
        end
        START: begin
            cfg_op0_tx_valid = 1'b1;
            cfg_op0_waddr = TRANSMIT_ADDR;
            cfg_op0_wdata = I2C_DEVICE_ADDR;

            cfg_op1_tx_valid = 1'b1;
            cfg_op1_waddr = COMMAND_ADDR;
            cfg_op1_wdata = START_AND_SEND;

            cfg_use_phase2 = 1'b1;
            cfg_op2_mode = 1'b1;
            cfg_op2_raddr = CHECK_SEND;
        end
        COMMAND_DATA: begin
            cfg_op0_tx_valid = 1'b1;
            cfg_op0_waddr = TRANSMIT_ADDR;
            cfg_op0_wdata = {1'b0, command_data, 6'b00_0000};

            cfg_op1_tx_valid = 1'b1;
            cfg_op1_waddr = COMMAND_ADDR;
            cfg_op1_wdata = SEND_EN_BYTE;

            cfg_use_phase2 = 1'b1;
            cfg_op2_mode = 1'b1;
            cfg_op2_raddr = CHECK_SEND;
        end
        SEND: begin
            cfg_op0_tx_valid = 1'b1;
            cfg_op0_waddr = TRANSMIT_ADDR;
            cfg_op0_wdata = data >> ((byte_cnt - 1'b1) * 8);

            cfg_op1_tx_valid = 1'b1;
            cfg_op1_waddr = COMMAND_ADDR;
            cfg_op1_wdata = SEND_EN_BYTE;

            cfg_use_phase2 = 1'b1;
            cfg_op2_mode = 1'b1;
            cfg_op2_raddr = CHECK_SEND;
        end
        STOP: begin
            cfg_op0_tx_valid = 1'b1;
            cfg_op0_waddr = TRANSMIT_ADDR;
            cfg_op0_wdata = data[7:0];

            cfg_op1_tx_valid = 1'b1;
            cfg_op1_waddr = COMMAND_ADDR;
            cfg_op1_wdata = STOP_AND_SEND_BYTE;

            cfg_use_phase2 = 1'b1;
            cfg_op2_mode = 1'b1;
            cfg_op2_raddr = CHECK_SEND;
        end
        default: begin
        end
    endcase
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        done <= 1'b0;
        busy <= 1'b0;
        step_start <= 1'b0;
        byte_cnt <= 8'd0;
        error_nack <= 1'b0;
    end
    else begin
        done <= 1'b0;
        step_start <= 1'b0;

        case (cur_state)
            IDLE: begin
                busy <= 1'b0;
                byte_cnt <= 8'd0;
            end
            PRESCALE_L,
            PRESCALE_H,
            CTRL_EN,
            COMMAND_DATA,
            STOP: begin
                busy <= 1'b1;
                if (!step_running && !step_done) step_start <= 1'b1;
            end
            START: begin
                busy <= 1'b1;
                if (!step_running && !step_done) begin
                    step_start <= 1'b1;
                    byte_cnt <= payload_len;
                end
            end
            SEND: begin
                busy <= 1'b1;
                if (!step_running && !step_done) step_start <= 1'b1;
                if (step_done) byte_cnt <= byte_cnt - 1'b1;
            end
            DONE: begin
                busy <= 1'b0;
                done <= 1'b1;
                error_nack <= ack_error;
            end
            default: begin
                busy <= 1'b0;
            end
        endcase
    end
end

i2c_step_engine u_i2c_step_engine(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .start_step(step_start),
    .op0_tx_valid(cfg_op0_tx_valid),
    .op0_waddr(cfg_op0_waddr),
    .op0_wdata(cfg_op0_wdata),
    .op1_tx_valid(cfg_op1_tx_valid),
    .op1_waddr(cfg_op1_waddr),
    .op1_wdata(cfg_op1_wdata),
    .op1_mode(cfg_op1_mode),
    .op1_raddr(cfg_op1_raddr),
    .op1_match_data(cfg_op1_match_data),
    .use_phase2(cfg_use_phase2),
    .op2_mode(cfg_op2_mode),
    .op2_raddr(cfg_op2_raddr),
    .op2_match_data(cfg_op2_match_data),
    .wait_done(wait_done),
    .tx_en(tx_en),
    .waddr(waddr),
    .wdata(wdata),
    .start(start_wait),
    .mode(mode),
    .raddr(raddr),
    .match_data(match_data),
    .running(step_running),
    .done(step_done),
    .phase(step_phase)
);

i2c_wait_tip u_i2c_wait_tip(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .start(start_wait),
    .match_data(match_data),
    .rdata(rdata),
    .mode(mode),
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
    .I_RADDR   (raddr),
    .O_RDATA   (rdata),
    .O_IIC_INT (iic_int),
    .SCL       (SCL),
    .SDA       (SDA)
);

endmodule
