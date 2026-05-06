module top(
    input sys_clk,
    input sys_rst_n,

    output wire dc,
    output wire spi_sclk,
    output wire spi_mosi
);

reg en;
reg [2:0] command_type;

reg [26:0] cnt;
localparam integer CLK_HZ = 27_000_000; // TODO: change to your real sys_clk frequency
localparam integer ONE_SEC_CNT = CLK_HZ - 1;
localparam [1:0]
    ST_INIT_PULSE = 2'd0,
    ST_WAIT_1S_A  = 2'd1,
    ST_WAIT_1S_B  = 2'd2;
reg [1:0] st;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        cnt          <= 27'd0;
        en           <= 1'b0;
        command_type <= 3'b001; // spi init
        st           <= ST_INIT_PULSE;
    end else begin
        // default low; en is one-cycle pulse
        en <= 1'b0;

        case (st)
            // Reset release: send spi init once
            ST_INIT_PULSE: begin
                command_type <= 3'b001;
                en           <= 1'b1;
                cnt          <= 27'd0;
                st           <= ST_WAIT_1S_A;
            end

            // Wait 1s then send 0x11
            ST_WAIT_1S_A: begin
                if (cnt >= ONE_SEC_CNT) begin
                    cnt          <= 27'd0;
                    command_type <= 3'b010;
                    en           <= 1'b1;
                    st           <= ST_WAIT_1S_B;
                end else begin
                    cnt <= cnt + 1'b1;
                end
            end

            // Wait 1s then send spi init, and loop
            ST_WAIT_1S_B: begin
                if (cnt >= ONE_SEC_CNT) begin
                    cnt          <= 27'd0;
                    command_type <= 3'b001;
                    en           <= 1'b1;
                    st           <= ST_WAIT_1S_A;
                end else begin
                    cnt <= cnt + 1'b1;
                end
            end

            default: begin
                st <= ST_INIT_PULSE;
            end
        endcase
    end
end


spi_driver u_spi_driver(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),

    .en(en),
    .command_type(command_type),

    .dc(dc),
    .spi_sclk(spi_sclk),
    .spi_mosi(spi_mosi)
);

endmodule
