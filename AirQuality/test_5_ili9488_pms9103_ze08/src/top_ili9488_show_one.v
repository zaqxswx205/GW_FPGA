module top_ili9488_show_one (
    input  wire sys_clk,
    input  wire sys_rst_n,
    input  wire pms_rx,
    input  wire ze08_rx,
    output wire spi_sclk,
    output wire spi_mosi,
    output wire spi_cs_n,
    output wire dcx,
    output wire lcd_rst_n,
    output wire lcd_bl
);

reg        sensor_update_req;
wire       sensor_update_ack;

reg [15:0] pm1_cf1;
reg [15:0] pm25_cf1;
reg [15:0] pm10_cf1;
reg [15:0] pcnt_03;
reg [15:0] pcnt_05;
reg [15:0] pcnt_10;
reg [15:0] ch2o;
reg [15:0] co2;
reg [15:0] voc;

wire        sensor_data_valid;
wire        ze08_data_valid;
wire [15:0] sensor_pm1_0;
wire [15:0] sensor_pm2_5;
wire [15:0] sensor_pm10;
wire [15:0] sensor_cnt_03um;
wire [15:0] sensor_cnt_05um;
wire [15:0] sensor_cnt_10um;
wire [15:0] ze08_ch2o;

pms9103_data u_pms9103_data (
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .rx(pms_rx),
    .data_ready(sensor_data_valid),
    .standard_pm1_0(sensor_pm1_0),
    .standard_pm2_5(sensor_pm2_5),
    .standard_pm10(sensor_pm10),
    .pm0_3(sensor_cnt_03um),
    .pm0_5(sensor_cnt_05um),
    .pm1_0(sensor_cnt_10um)
);

ze08_ch2o_data u_ze08_ch2o_data (
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .rx(ze08_rx),
    .data_ready(ze08_data_valid),
    .ch2o_data(ze08_ch2o)
);

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        sensor_update_req <= 1'b0;
        pm1_cf1  <= 16'd0;
        pm25_cf1 <= 16'd0;
        pm10_cf1 <= 16'd0;
        pcnt_03  <= 16'd0;
        pcnt_05  <= 16'd0;
        pcnt_10  <= 16'd0;
        ch2o     <= 16'd0;
        co2      <= 16'd0;
        voc      <= 16'd0;
    end else begin
        if (sensor_update_ack)
            sensor_update_req <= 1'b0;

        if (sensor_data_valid && !sensor_update_req) begin
            pm1_cf1  <= sensor_pm1_0;
            pm25_cf1 <= sensor_pm2_5;
            pm10_cf1 <= sensor_pm10;
            pcnt_03  <= sensor_cnt_03um;
            pcnt_05  <= sensor_cnt_05um;
            pcnt_10  <= sensor_cnt_10um;
            sensor_update_req <= 1'b1;
        end

        if (ze08_data_valid && !sensor_update_req) begin
            ch2o <= ze08_ch2o;
            sensor_update_req <= 1'b1;
        end
    end
end

ili9488_ctrl u_ili9488_ctrl (
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .sensor_update(sensor_update_req),
    .pm1_cf1(pm1_cf1),
    .pm25_cf1(pm25_cf1),
    .pm10_cf1(pm10_cf1),
    .pcnt_03(pcnt_03),
    .pcnt_05(pcnt_05),
    .pcnt_10(pcnt_10),
    .ch2o(ch2o),
    .co2(co2),
    .voc(voc),
    .spi_sclk(spi_sclk),
    .spi_mosi(spi_mosi),
    .spi_cs_n(spi_cs_n),
    .dcx(dcx),
    .lcd_rst_n(lcd_rst_n),
    .lcd_bl(lcd_bl),
    .sensor_update_ack(sensor_update_ack)
);

endmodule
