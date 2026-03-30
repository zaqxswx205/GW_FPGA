module i2c_write_one_bit(
    input sys_clk,
    input sys_rst_n,

    output scl,
    inout sda
);

parameter I2C_ADDR = 8'h78;
parameter CONTROL  = 8'h00;
parameter COMMAND  = 8'hae;

parameter IDLE         = 6'b00_0001;
parameter START        = 6'b00_0010;
parameter ADDR         = 6'b00_0100;
parameter CONTROL_BYTE = 6'b00_1000;
parameter COMMAND_BYTE = 6'b01_0000;
parameter STOP         = 6'b10_0000;

wire i2c_clk;

reg scl_buf;
reg sda_out;
reg sda_en;
wire sda_in;

assign scl = scl_buf;
assign sda = sda_en ? sda_out : 1'bz;
assign sda_in = sda;

reg [5:0] cur_state;
reg [5:0] next_state;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        cur_state <= IDLE;
    end
    else begin
        cur_state <= next_state;
    end
end

reg [7:0] data;
reg [3:0] bit_cnt;
always @(*) begin
    next_state = cur_state;
    case (cur_state)
        IDLE:begin
            next_state = START;
        end
        START:begin
            data <= I2C_ADDR;
            next_state = (sda) ? START : ADDR;
        end
        ADDR:begin
            data <= CONTROL;
            next_state = CONTROL_BYTE;
        end
        CONTROL_BYTE:begin
            data <= COMMAND;
            next_state = COMMAND_BYTE;
        end
        COMMAND_BYTE:begin
            next_state = STOP;
        end
        STOP:begin
            next_state = IDLE;
        end
        default:begin
            next_state = IDLE;
        end
    endcase
end

reg start;
wire send_scl;
wire done;
wire need_release;
wire send_sda;

always @(posedge i2c_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        scl_buf <= 1'b1;
        sda_out <= 1'b1;
        sda_en <= 1'b1;
        bit_cnt <= 4'd0;
    end
    else begin
        case (cur_state)
            IDLE:begin
                scl_buf <= 1'b1;
                sda_out <= 1'b1;
                sda_en <= 1'b1;
                bit_cnt <= 4'd0;
            end
            START:begin
                sda_en <= 1'b1;
                sda_out <= 1'b0;
            end
            ADDR:begin
                start <= 1'b1;
                scl_buf <= send_scl;
                sda_out <= send_sda;
                sda_en <= need_release;
            end
            CONTROL_BYTE:begin
            end
            COMMAND_BYTE:begin
            end
            STOP:begin
            end
            default:begin
            end
        endcase
    end
end

i2c_send u_i2c_send(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),

    .i2c_clk(i2c_clk),
    .data(data),
    .start(start),
    .scl(send_scl),
    .sda_out(send_sda),
    .done(done),
    .need_release(need_release)
);

i2c_clock u_i2c_clock(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),

    .i2c_clk(i2c_clk)
);

endmodule