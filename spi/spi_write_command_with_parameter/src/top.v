module top(
    input sys_clk,
    input sys_rst_n,

    output wire dcx,
    output wire spi_sclk,
    output wire spi_mosi
);

reg en;
reg [7:0] command;
reg [7:0] param  ;
reg [2:0] command_type;

reg [26:0] cnt;
localparam integer CLK_HZ = 27_000_000;
localparam integer ONE_SEC_CNT = CLK_HZ - 1;

localparam [2:0]
    ST_INIT          = 3'd0,
    ST_WAIT_AFTER_INIT = 3'd1,
    ST_SEND_11       = 3'd2,
    ST_WAIT_AFTER_11 = 3'd3,
    ST_SEND_3A_55    = 3'd4,
    ST_WAIT_AFTER_3A = 3'd5;

reg [2:0] st;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        cnt          <= 27'd0;
        en           <= 1'b0;
        command      <= 8'h00;
        param        <= 8'h00;
        command_type <= 3'b001; // init
        st           <= ST_INIT;
    end else begin
        en <= 1'b0; // one-cycle pulse

        case (st)
            ST_INIT: begin
                command_type <= 3'b001; // spi init
                command      <= 8'h00;
                param        <= 8'h00;
                en           <= 1'b1;
                cnt          <= 27'd0;
                st           <= ST_WAIT_AFTER_INIT;
            end

            ST_WAIT_AFTER_INIT: begin
                if (cnt >= ONE_SEC_CNT) begin
                    cnt <= 27'd0;
                    st  <= ST_SEND_11;
                end else begin
                    cnt <= cnt + 1'b1;
                end
            end

            ST_SEND_11: begin
                command_type <= 3'b010; // command only
                command      <= 8'h11;
                param        <= 8'h00;
                en           <= 1'b1;
                cnt          <= 27'd0;
                st           <= ST_WAIT_AFTER_11;
            end

            ST_WAIT_AFTER_11: begin
                if (cnt >= ONE_SEC_CNT) begin
                    cnt <= 27'd0;
                    st  <= ST_SEND_3A_55;
                end else begin
                    cnt <= cnt + 1'b1;
                end
            end

            ST_SEND_3A_55: begin
                command_type <= 3'b100; // command + parameter
                command      <= 8'h3A;
                param        <= 8'h55;
                en           <= 1'b1;
                cnt          <= 27'd0;
                st           <= ST_WAIT_AFTER_3A;
            end

            ST_WAIT_AFTER_3A: begin
                if (cnt >= ONE_SEC_CNT) begin
                    cnt <= 27'd0;
                    st  <= ST_INIT;
                end else begin
                    cnt <= cnt + 1'b1;
                end
            end

            default: begin
                st <= ST_INIT;
            end
        endcase
    end
end

spi_driver u_spi_driver(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .en(en),
    .command(command),
    .param(param),
    .command_type(command_type),
    .dcx(dcx),
    .spi_sclk(spi_sclk),
    .spi_mosi(spi_mosi)
);

endmodule
