module ssd1309_region_write(
    input sys_clk,
    input sys_rst_n,

    // input [7:0] page,
    // input [7:0] start_col,
    // input [7:0] col_length,

    output scl,
    inout sda
);

parameter PAGE = 8'hb0 + 8'd1;

parameter START_COL = 8'h01;
parameter STOP_COL = 8'h11;

parameter PIXEL_DATA = 8'h34;
parameter PIXEL_LENGTH = 8'd2;

parameter IDLE              = 6'b00_0001;
parameter SET_PAGE          = 6'b00_0010;
parameter SET_START_COL     = 6'b00_0100;
parameter SET_STOP_COL      = 6'b00_1000;
parameter WRITE_PIXEL       = 6'b01_0000;
parameter STOP              = 6'b10_0000;

reg [5:0] cur_state;
reg [5:0] next_state;

always @(posedge sys_clk or negedge sys_rst_n)begin
    if (!sys_rst_n) begin
        cur_state <= IDLE;
    end
    else begin
        cur_state <= next_state;
    end
end

wire done;
wire busy;
reg c_d;
reg start;
reg [7:0] command;
reg [7:0] param_1;
reg [7:0] param_2;
reg [1:0] with_param;
reg [7:0] pixel_data;
reg [7:0] pixel_length;

always @(*) begin
    case (cur_state)
        IDLE:next_state = SET_PAGE;
        SET_PAGE:next_state = (done) ? SET_START_COL : SET_PAGE;
        SET_START_COL:next_state = (done) ? SET_STOP_COL : SET_START_COL;
        SET_STOP_COL:next_state = (done) ? WRITE_PIXEL : SET_STOP_COL;
        WRITE_PIXEL:next_state = (done) ? STOP : WRITE_PIXEL;
        STOP:next_state = IDLE;
        default: next_state = IDLE;
    endcase
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        c_d <= 1'b0;
        start <= 1'b0;
        with_param <= 2'b00;
    end
    else begin
        case (cur_state)
            IDLE:begin
                c_d <= 1'b0;
                start <= 1'b0;
                with_param <= 2'b00;
            end
            SET_PAGE:begin
                c_d <= 1'b0;
                start <= 1'b1;
                command <= PAGE;
                with_param <= 2'b00;
            end
            SET_START_COL:begin
                c_d <= 1'b0;
                start <= 1'b1;
                command <= START_COL;
                with_param <= 2'b00;
            end
            SET_STOP_COL:begin
                c_d <= 1'b0;
                start <= 1'b1;
                command <= STOP_COL;
                with_param <= 2'b00;
            end
            WRITE_PIXEL:begin
                c_d <= 1'b1;
                start <= 1'b1;
                pixel_data <= PIXEL_DATA;
                pixel_length <= PIXEL_LENGTH;
            end
            STOP:begin
                c_d <= 1'b0;
                start <= 1'b0;
                with_param <= 2'b00;
            end
            default:begin
                c_d <= 1'b0;
                start <= 1'b0;
                with_param <= 2'b00;
            end
        endcase
    end
end

i2c_driver u_i2c_driver(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .start(start),
    .c_d(c_d),
    .command(command),
    .param_1(param_1),
    .param_2(param_2),
    .with_param(with_param),
    .pixel_data(pixel_data),
    .pixel_length(pixel_length),
    .done(done),
    .busy(busy),
    .scl(scl),
    .sda(sda)
);

endmodule