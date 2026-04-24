module top (
    input sys_clk,
    input sys_rst_n,

    output init_done,
    inout SCL,
    inout SDA
);

parameter PAGE = 8'hb0 + 8'd1;

parameter START_COL = 8'h01;
parameter STOP_COL = 8'h11;

parameter PIXEL_DATA = 8'h34;

localparam [6:0]
    IDLE              = 7'b000_0001,
    INIT              = 7'b000_0010,
    SET_PAGE          = 7'b000_0100,
    SET_START_COL     = 7'b000_1000,
    SET_STOP_COL      = 7'b001_0000,
    WRITE_PIXEL       = 7'b010_0000,
    STOP              = 7'b100_0000;

//i2c_driver
reg en;
reg init;
reg command_data;
wire i2c_done;
wire i2c_busy;
reg [7:0] payload_len;
reg [7:0] command;
reg [63:0] data;

reg [6:0] cur_state;
reg [6:0] next_state;

assign init_done = (cur_state == INIT && i2c_done) ? 1'b0 : 1'b1;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) cur_state <= IDLE;
    else cur_state <= next_state;
end

always @(*) begin
    case (cur_state)
        IDLE:next_state = INIT;
        INIT:next_state = (i2c_done) ? SET_PAGE : INIT;
        SET_PAGE:next_state = (i2c_done) ? SET_START_COL : SET_PAGE;
        SET_START_COL:next_state = (i2c_done) ? SET_STOP_COL : SET_START_COL;
        SET_STOP_COL:next_state = (i2c_done) ? WRITE_PIXEL : SET_STOP_COL;
        WRITE_PIXEL:next_state = (i2c_done) ? STOP : WRITE_PIXEL;
        STOP:next_state = IDLE;
        default:next_state = IDLE;
    endcase
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        en <= 1'b0;
        init <= 1'b0;
        command_data <= 1'b0;
        payload_len <= 8'd0;
        command <= 8'd0;
    end
    else begin
        en <= 1'b0;
        case (cur_state)
            IDLE:begin
                en <= 1'b0;
                init <= 1'b0;
                command_data <= 1'b0;
                payload_len <= 8'd0;
                command <= 8'd0;
            end
            INIT:begin
                en <= (!i2c_busy && !i2c_done) ? 1'b1 : 1'b0;
                init <= 1'b1;
                command_data <= 1'b0;
            end
            SET_PAGE:begin
                en <= (!i2c_busy && !i2c_done) ? 1'b1 : 1'b0;
                init <= 1'b0;
                payload_len <= 8'd1;
                data <= {PAGE};
                command_data <= 1'b0;
            end
            SET_START_COL:begin
                en <= (!i2c_busy && !i2c_done) ? 1'b1 : 1'b0;
                init <= 1'b0;
                payload_len <= 8'd1;
                data <= {START_COL};
                command_data <= 1'b0;
            end
            SET_STOP_COL:begin
                en <= (!i2c_busy && !i2c_done) ? 1'b1 : 1'b0;
                init <= 1'b0;
                payload_len <= 8'd1;
                data <= {STOP_COL};
                command_data <= 1'b0;
            end
            WRITE_PIXEL:begin
                en <= (!i2c_busy && !i2c_done) ? 1'b1 : 1'b0;
                init <= 1'b0;
                payload_len <= 8'd8;
                data <= {PIXEL_DATA+8'd1,PIXEL_DATA+8'd2,PIXEL_DATA+8'd3,PIXEL_DATA+8'd4,PIXEL_DATA+8'd5,PIXEL_DATA+8'd6,PIXEL_DATA+8'd7,PIXEL_DATA+8'd8};
                command_data <= 1'b1;
            end
            STOP:begin
                en <= 1'b0;
                init <= 1'b0;
                payload_len <= 8'd0;
                command_data <= 1'b0;
            end
            default:begin
                en <= 1'b0;
                init <= 1'b0;
                payload_len <= 8'd0;
                command_data <= 1'b0;
            end
        endcase
    end
end

i2c_driver u_i2c_driver(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),

    .en(en),
    .INIT(init),
    .command_data(command_data),
    .payload_len(payload_len),
    .data(data),
    .done(i2c_done),
    .busy(i2c_busy),
    .SCL(SCL),
    .SDA(SDA)
);  

endmodule