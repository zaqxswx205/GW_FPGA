module i2c_write_addr (
    input sys_clk,
    input sys_rst_n,
    
    input i2c_send_addr_set,
    output scl,
    output sda
);

parameter IDLE  = 4'b0001;
parameter START = 4'b0010;
parameter SEND  = 4'b0100;
parameter ACK   = 4'b1000;

parameter I2C_ADDR = 7'h78;

reg [3:0] state;
reg scl_buf;
reg sda_buf;
reg [3:0] bit_cnt;

assign scl = scl_buf;
assign sda = sda_buf;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        state <= IDLE;
        sda_buf <= 1'b1;
        bit_cnt <= 4'd0;
    end
    else begin
        case (state)
            IDLE:begin
                sda_buf <= 1'b1;
                state <= (i2c_send_addr_set) ? START : IDLE;
            end
            START:begin
                sda_buf <= 1'b0;
                state <= SEND;
            end
            SEND:begin
                if (!scl_buf) begin
                    sda_buf <= I2C_ADDR[7 - bit_cnt];
                    bit_cnt <= bit_cnt + 1'b1;
                    state <= (bit_cnt == 8) ? ACK : SEND;
                end
                else begin
                    bit_cnt <= bit_cnt;
                    state <= SEND;
                end
            end
            ACK:begin
                bit_cnt <= 4'd0;
                state <= IDLE;
            end
            default:begin
                state <= IDLE;
            end
        endcase
    end
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (~sys_rst_n) begin
        scl_buf <= 1'b1;
    end
    else if (state == SEND) begin
        scl_buf <= ~scl_buf;
    end
    else begin
        scl_buf <= 1'b1;
    end
end

endmodule