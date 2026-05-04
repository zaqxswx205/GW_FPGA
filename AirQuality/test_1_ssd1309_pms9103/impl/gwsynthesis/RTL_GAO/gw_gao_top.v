module gw_gao(
    \standard_pm1_0[15] ,
    \standard_pm1_0[14] ,
    \standard_pm1_0[13] ,
    \standard_pm1_0[12] ,
    \standard_pm1_0[11] ,
    \standard_pm1_0[10] ,
    \standard_pm1_0[9] ,
    \standard_pm1_0[8] ,
    \standard_pm1_0[7] ,
    \standard_pm1_0[6] ,
    \standard_pm1_0[5] ,
    \standard_pm1_0[4] ,
    \standard_pm1_0[3] ,
    \standard_pm1_0[2] ,
    \standard_pm1_0[1] ,
    \standard_pm1_0[0] ,
    \standard_pm2_5[15] ,
    \standard_pm2_5[14] ,
    \standard_pm2_5[13] ,
    \standard_pm2_5[12] ,
    \standard_pm2_5[11] ,
    \standard_pm2_5[10] ,
    \standard_pm2_5[9] ,
    \standard_pm2_5[8] ,
    \standard_pm2_5[7] ,
    \standard_pm2_5[6] ,
    \standard_pm2_5[5] ,
    \standard_pm2_5[4] ,
    \standard_pm2_5[3] ,
    \standard_pm2_5[2] ,
    \standard_pm2_5[1] ,
    \standard_pm2_5[0] ,
    \standard_pm10[15] ,
    \standard_pm10[14] ,
    \standard_pm10[13] ,
    \standard_pm10[12] ,
    \standard_pm10[11] ,
    \standard_pm10[10] ,
    \standard_pm10[9] ,
    \standard_pm10[8] ,
    \standard_pm10[7] ,
    \standard_pm10[6] ,
    \standard_pm10[5] ,
    \standard_pm10[4] ,
    \standard_pm10[3] ,
    \standard_pm10[2] ,
    \standard_pm10[1] ,
    \standard_pm10[0] ,
    \pm0_3[15] ,
    \pm0_3[14] ,
    \pm0_3[13] ,
    \pm0_3[12] ,
    \pm0_3[11] ,
    \pm0_3[10] ,
    \pm0_3[9] ,
    \pm0_3[8] ,
    \pm0_3[7] ,
    \pm0_3[6] ,
    \pm0_3[5] ,
    \pm0_3[4] ,
    \pm0_3[3] ,
    \pm0_3[2] ,
    \pm0_3[1] ,
    \pm0_3[0] ,
    \pm0_5[15] ,
    \pm0_5[14] ,
    \pm0_5[13] ,
    \pm0_5[12] ,
    \pm0_5[11] ,
    \pm0_5[10] ,
    \pm0_5[9] ,
    \pm0_5[8] ,
    \pm0_5[7] ,
    \pm0_5[6] ,
    \pm0_5[5] ,
    \pm0_5[4] ,
    \pm0_5[3] ,
    \pm0_5[2] ,
    \pm0_5[1] ,
    \pm0_5[0] ,
    \pm1_0[15] ,
    \pm1_0[14] ,
    \pm1_0[13] ,
    \pm1_0[12] ,
    \pm1_0[11] ,
    \pm1_0[10] ,
    \pm1_0[9] ,
    \pm1_0[8] ,
    \pm1_0[7] ,
    \pm1_0[6] ,
    \pm1_0[5] ,
    \pm1_0[4] ,
    \pm1_0[3] ,
    \pm1_0[2] ,
    \pm1_0[1] ,
    \pm1_0[0] ,
    pms_data_ready,
    sys_clk,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input \standard_pm1_0[15] ;
input \standard_pm1_0[14] ;
input \standard_pm1_0[13] ;
input \standard_pm1_0[12] ;
input \standard_pm1_0[11] ;
input \standard_pm1_0[10] ;
input \standard_pm1_0[9] ;
input \standard_pm1_0[8] ;
input \standard_pm1_0[7] ;
input \standard_pm1_0[6] ;
input \standard_pm1_0[5] ;
input \standard_pm1_0[4] ;
input \standard_pm1_0[3] ;
input \standard_pm1_0[2] ;
input \standard_pm1_0[1] ;
input \standard_pm1_0[0] ;
input \standard_pm2_5[15] ;
input \standard_pm2_5[14] ;
input \standard_pm2_5[13] ;
input \standard_pm2_5[12] ;
input \standard_pm2_5[11] ;
input \standard_pm2_5[10] ;
input \standard_pm2_5[9] ;
input \standard_pm2_5[8] ;
input \standard_pm2_5[7] ;
input \standard_pm2_5[6] ;
input \standard_pm2_5[5] ;
input \standard_pm2_5[4] ;
input \standard_pm2_5[3] ;
input \standard_pm2_5[2] ;
input \standard_pm2_5[1] ;
input \standard_pm2_5[0] ;
input \standard_pm10[15] ;
input \standard_pm10[14] ;
input \standard_pm10[13] ;
input \standard_pm10[12] ;
input \standard_pm10[11] ;
input \standard_pm10[10] ;
input \standard_pm10[9] ;
input \standard_pm10[8] ;
input \standard_pm10[7] ;
input \standard_pm10[6] ;
input \standard_pm10[5] ;
input \standard_pm10[4] ;
input \standard_pm10[3] ;
input \standard_pm10[2] ;
input \standard_pm10[1] ;
input \standard_pm10[0] ;
input \pm0_3[15] ;
input \pm0_3[14] ;
input \pm0_3[13] ;
input \pm0_3[12] ;
input \pm0_3[11] ;
input \pm0_3[10] ;
input \pm0_3[9] ;
input \pm0_3[8] ;
input \pm0_3[7] ;
input \pm0_3[6] ;
input \pm0_3[5] ;
input \pm0_3[4] ;
input \pm0_3[3] ;
input \pm0_3[2] ;
input \pm0_3[1] ;
input \pm0_3[0] ;
input \pm0_5[15] ;
input \pm0_5[14] ;
input \pm0_5[13] ;
input \pm0_5[12] ;
input \pm0_5[11] ;
input \pm0_5[10] ;
input \pm0_5[9] ;
input \pm0_5[8] ;
input \pm0_5[7] ;
input \pm0_5[6] ;
input \pm0_5[5] ;
input \pm0_5[4] ;
input \pm0_5[3] ;
input \pm0_5[2] ;
input \pm0_5[1] ;
input \pm0_5[0] ;
input \pm1_0[15] ;
input \pm1_0[14] ;
input \pm1_0[13] ;
input \pm1_0[12] ;
input \pm1_0[11] ;
input \pm1_0[10] ;
input \pm1_0[9] ;
input \pm1_0[8] ;
input \pm1_0[7] ;
input \pm1_0[6] ;
input \pm1_0[5] ;
input \pm1_0[4] ;
input \pm1_0[3] ;
input \pm1_0[2] ;
input \pm1_0[1] ;
input \pm1_0[0] ;
input pms_data_ready;
input sys_clk;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire \standard_pm1_0[15] ;
wire \standard_pm1_0[14] ;
wire \standard_pm1_0[13] ;
wire \standard_pm1_0[12] ;
wire \standard_pm1_0[11] ;
wire \standard_pm1_0[10] ;
wire \standard_pm1_0[9] ;
wire \standard_pm1_0[8] ;
wire \standard_pm1_0[7] ;
wire \standard_pm1_0[6] ;
wire \standard_pm1_0[5] ;
wire \standard_pm1_0[4] ;
wire \standard_pm1_0[3] ;
wire \standard_pm1_0[2] ;
wire \standard_pm1_0[1] ;
wire \standard_pm1_0[0] ;
wire \standard_pm2_5[15] ;
wire \standard_pm2_5[14] ;
wire \standard_pm2_5[13] ;
wire \standard_pm2_5[12] ;
wire \standard_pm2_5[11] ;
wire \standard_pm2_5[10] ;
wire \standard_pm2_5[9] ;
wire \standard_pm2_5[8] ;
wire \standard_pm2_5[7] ;
wire \standard_pm2_5[6] ;
wire \standard_pm2_5[5] ;
wire \standard_pm2_5[4] ;
wire \standard_pm2_5[3] ;
wire \standard_pm2_5[2] ;
wire \standard_pm2_5[1] ;
wire \standard_pm2_5[0] ;
wire \standard_pm10[15] ;
wire \standard_pm10[14] ;
wire \standard_pm10[13] ;
wire \standard_pm10[12] ;
wire \standard_pm10[11] ;
wire \standard_pm10[10] ;
wire \standard_pm10[9] ;
wire \standard_pm10[8] ;
wire \standard_pm10[7] ;
wire \standard_pm10[6] ;
wire \standard_pm10[5] ;
wire \standard_pm10[4] ;
wire \standard_pm10[3] ;
wire \standard_pm10[2] ;
wire \standard_pm10[1] ;
wire \standard_pm10[0] ;
wire \pm0_3[15] ;
wire \pm0_3[14] ;
wire \pm0_3[13] ;
wire \pm0_3[12] ;
wire \pm0_3[11] ;
wire \pm0_3[10] ;
wire \pm0_3[9] ;
wire \pm0_3[8] ;
wire \pm0_3[7] ;
wire \pm0_3[6] ;
wire \pm0_3[5] ;
wire \pm0_3[4] ;
wire \pm0_3[3] ;
wire \pm0_3[2] ;
wire \pm0_3[1] ;
wire \pm0_3[0] ;
wire \pm0_5[15] ;
wire \pm0_5[14] ;
wire \pm0_5[13] ;
wire \pm0_5[12] ;
wire \pm0_5[11] ;
wire \pm0_5[10] ;
wire \pm0_5[9] ;
wire \pm0_5[8] ;
wire \pm0_5[7] ;
wire \pm0_5[6] ;
wire \pm0_5[5] ;
wire \pm0_5[4] ;
wire \pm0_5[3] ;
wire \pm0_5[2] ;
wire \pm0_5[1] ;
wire \pm0_5[0] ;
wire \pm1_0[15] ;
wire \pm1_0[14] ;
wire \pm1_0[13] ;
wire \pm1_0[12] ;
wire \pm1_0[11] ;
wire \pm1_0[10] ;
wire \pm1_0[9] ;
wire \pm1_0[8] ;
wire \pm1_0[7] ;
wire \pm1_0[6] ;
wire \pm1_0[5] ;
wire \pm1_0[4] ;
wire \pm1_0[3] ;
wire \pm1_0[2] ;
wire \pm1_0[1] ;
wire \pm1_0[0] ;
wire pms_data_ready;
wire sys_clk;
wire tms_pad_i;
wire tck_pad_i;
wire tdi_pad_i;
wire tdo_pad_o;
wire tms_i_c;
wire tck_i_c;
wire tdi_i_c;
wire tdo_o_c;
wire [9:0] control0;
wire gao_jtag_tck;
wire gao_jtag_reset;
wire run_test_idle_er1;
wire run_test_idle_er2;
wire shift_dr_capture_dr;
wire update_dr;
wire pause_dr;
wire enable_er1;
wire enable_er2;
wire gao_jtag_tdi;
wire tdo_er1;

IBUF tms_ibuf (
    .I(tms_pad_i),
    .O(tms_i_c)
);

IBUF tck_ibuf (
    .I(tck_pad_i),
    .O(tck_i_c)
);

IBUF tdi_ibuf (
    .I(tdi_pad_i),
    .O(tdi_i_c)
);

OBUF tdo_obuf (
    .I(tdo_o_c),
    .O(tdo_pad_o)
);

GW_JTAG  u_gw_jtag(
    .tms_pad_i(tms_i_c),
    .tck_pad_i(tck_i_c),
    .tdi_pad_i(tdi_i_c),
    .tdo_pad_o(tdo_o_c),
    .tck_o(gao_jtag_tck),
    .test_logic_reset_o(gao_jtag_reset),
    .run_test_idle_er1_o(run_test_idle_er1),
    .run_test_idle_er2_o(run_test_idle_er2),
    .shift_dr_capture_dr_o(shift_dr_capture_dr),
    .update_dr_o(update_dr),
    .pause_dr_o(pause_dr),
    .enable_er1_o(enable_er1),
    .enable_er2_o(enable_er2),
    .tdi_o(gao_jtag_tdi),
    .tdo_er1_i(tdo_er1),
    .tdo_er2_i(1'b0)
);

gw_con_top  u_icon_top(
    .tck_i(gao_jtag_tck),
    .tdi_i(gao_jtag_tdi),
    .tdo_o(tdo_er1),
    .rst_i(gao_jtag_reset),
    .control0(control0[9:0]),
    .enable_i(enable_er1),
    .shift_dr_capture_dr_i(shift_dr_capture_dr),
    .update_dr_i(update_dr)
);

ao_top_0  u_la0_top(
    .control(control0[9:0]),
    .trig0_i(pms_data_ready),
    .data_i({\standard_pm1_0[15] ,\standard_pm1_0[14] ,\standard_pm1_0[13] ,\standard_pm1_0[12] ,\standard_pm1_0[11] ,\standard_pm1_0[10] ,\standard_pm1_0[9] ,\standard_pm1_0[8] ,\standard_pm1_0[7] ,\standard_pm1_0[6] ,\standard_pm1_0[5] ,\standard_pm1_0[4] ,\standard_pm1_0[3] ,\standard_pm1_0[2] ,\standard_pm1_0[1] ,\standard_pm1_0[0] ,\standard_pm2_5[15] ,\standard_pm2_5[14] ,\standard_pm2_5[13] ,\standard_pm2_5[12] ,\standard_pm2_5[11] ,\standard_pm2_5[10] ,\standard_pm2_5[9] ,\standard_pm2_5[8] ,\standard_pm2_5[7] ,\standard_pm2_5[6] ,\standard_pm2_5[5] ,\standard_pm2_5[4] ,\standard_pm2_5[3] ,\standard_pm2_5[2] ,\standard_pm2_5[1] ,\standard_pm2_5[0] ,\standard_pm10[15] ,\standard_pm10[14] ,\standard_pm10[13] ,\standard_pm10[12] ,\standard_pm10[11] ,\standard_pm10[10] ,\standard_pm10[9] ,\standard_pm10[8] ,\standard_pm10[7] ,\standard_pm10[6] ,\standard_pm10[5] ,\standard_pm10[4] ,\standard_pm10[3] ,\standard_pm10[2] ,\standard_pm10[1] ,\standard_pm10[0] ,\pm0_3[15] ,\pm0_3[14] ,\pm0_3[13] ,\pm0_3[12] ,\pm0_3[11] ,\pm0_3[10] ,\pm0_3[9] ,\pm0_3[8] ,\pm0_3[7] ,\pm0_3[6] ,\pm0_3[5] ,\pm0_3[4] ,\pm0_3[3] ,\pm0_3[2] ,\pm0_3[1] ,\pm0_3[0] ,\pm0_5[15] ,\pm0_5[14] ,\pm0_5[13] ,\pm0_5[12] ,\pm0_5[11] ,\pm0_5[10] ,\pm0_5[9] ,\pm0_5[8] ,\pm0_5[7] ,\pm0_5[6] ,\pm0_5[5] ,\pm0_5[4] ,\pm0_5[3] ,\pm0_5[2] ,\pm0_5[1] ,\pm0_5[0] ,\pm1_0[15] ,\pm1_0[14] ,\pm1_0[13] ,\pm1_0[12] ,\pm1_0[11] ,\pm1_0[10] ,\pm1_0[9] ,\pm1_0[8] ,\pm1_0[7] ,\pm1_0[6] ,\pm1_0[5] ,\pm1_0[4] ,\pm1_0[3] ,\pm1_0[2] ,\pm1_0[1] ,\pm1_0[0] ,pms_data_ready}),
    .clk_i(sys_clk)
);

endmodule
