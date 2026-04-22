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

localparam [3:0]
    IDLE = 4'b0001,
    INIT = 4'b0010,
    SEND = 4'b0100,
    STOP = 4'b1000;

//i2c_driver
reg en;
reg init;
reg command_data;
wire i2c_done;
wire i2c_busy;
reg [7:0] length;
reg [7:0] command;

reg [3:0] cur_state;
reg [3:0] next_state;

assign init_done = (cur_state == INIT && i2c_done) ? 1'b0 : 1'b1;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) cur_state <= IDLE;
    else cur_state <= next_state;
end

always @(*) begin
    case (cur_state)
        IDLE:next_state = INIT;
        INIT:next_state = (i2c_done) ? SEND : INIT;
        SEND:next_state = (i2c_done) ? STOP : SEND;
        STOP:next_state = IDLE;
        default:next_state = IDLE;
    endcase
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        en <= 1'b0;
        init <= 1'b0;
        command_data <= 1'b0;
        length <= 8'd0;
        command <= 8'd0;
    end
    else begin
        en <= 1'b0;
        case (cur_state)
            IDLE:begin
                en <= 1'b0;
                init <= 1'b0;
                command_data <= 1'b0;
                length <= 8'd0;
                command <= 8'd0;
            end
            INIT:begin
                en <= (!i2c_busy && !i2c_done) ? 1'b1 : 1'b0;
                init <= 1'b1;
                command_data <= 1'b0;
            end
            SEND:begin
                en <= (!i2c_busy && !i2c_done) ? 1'b1 : 1'b0;
                init <= 1'b0;
                length <= 8'd1;
                command <= PAGE;
                command_data <= 1'b0;
            end
            STOP:begin
                en <= 1'b0;
                init <= 1'b0;
                command_data <= 1'b0;
            end
            default:begin
                en <= 1'b0;
                init <= 1'b0;
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
    .length(length),
    .command(command),
    .done(i2c_done),
    .busy(i2c_busy),
    .SCL(SCL),
    .SDA(SDA)
);  

endmodule