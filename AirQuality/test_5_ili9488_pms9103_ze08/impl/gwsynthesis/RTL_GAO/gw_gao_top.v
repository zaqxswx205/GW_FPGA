module gw_gao(
    \pm1_cf1[15] ,
    \pm1_cf1[14] ,
    \pm1_cf1[13] ,
    \pm1_cf1[12] ,
    \pm1_cf1[11] ,
    \pm1_cf1[10] ,
    \pm1_cf1[9] ,
    \pm1_cf1[8] ,
    \pm1_cf1[7] ,
    \pm1_cf1[6] ,
    \pm1_cf1[5] ,
    \pm1_cf1[4] ,
    \pm1_cf1[3] ,
    \pm1_cf1[2] ,
    \pm1_cf1[1] ,
    \pm1_cf1[0] ,
    \pm25_cf1[15] ,
    \pm25_cf1[14] ,
    \pm25_cf1[13] ,
    \pm25_cf1[12] ,
    \pm25_cf1[11] ,
    \pm25_cf1[10] ,
    \pm25_cf1[9] ,
    \pm25_cf1[8] ,
    \pm25_cf1[7] ,
    \pm25_cf1[6] ,
    \pm25_cf1[5] ,
    \pm25_cf1[4] ,
    \pm25_cf1[3] ,
    \pm25_cf1[2] ,
    \pm25_cf1[1] ,
    \pm25_cf1[0] ,
    \pm10_cf1[15] ,
    \pm10_cf1[14] ,
    \pm10_cf1[13] ,
    \pm10_cf1[12] ,
    \pm10_cf1[11] ,
    \pm10_cf1[10] ,
    \pm10_cf1[9] ,
    \pm10_cf1[8] ,
    \pm10_cf1[7] ,
    \pm10_cf1[6] ,
    \pm10_cf1[5] ,
    \pm10_cf1[4] ,
    \pm10_cf1[3] ,
    \pm10_cf1[2] ,
    \pm10_cf1[1] ,
    \pm10_cf1[0] ,
    \pcnt_03[15] ,
    \pcnt_03[14] ,
    \pcnt_03[13] ,
    \pcnt_03[12] ,
    \pcnt_03[11] ,
    \pcnt_03[10] ,
    \pcnt_03[9] ,
    \pcnt_03[8] ,
    \pcnt_03[7] ,
    \pcnt_03[6] ,
    \pcnt_03[5] ,
    \pcnt_03[4] ,
    \pcnt_03[3] ,
    \pcnt_03[2] ,
    \pcnt_03[1] ,
    \pcnt_03[0] ,
    \pcnt_05[15] ,
    \pcnt_05[14] ,
    \pcnt_05[13] ,
    \pcnt_05[12] ,
    \pcnt_05[11] ,
    \pcnt_05[10] ,
    \pcnt_05[9] ,
    \pcnt_05[8] ,
    \pcnt_05[7] ,
    \pcnt_05[6] ,
    \pcnt_05[5] ,
    \pcnt_05[4] ,
    \pcnt_05[3] ,
    \pcnt_05[2] ,
    \pcnt_05[1] ,
    \pcnt_05[0] ,
    \pcnt_10[15] ,
    \pcnt_10[14] ,
    \pcnt_10[13] ,
    \pcnt_10[12] ,
    \pcnt_10[11] ,
    \pcnt_10[10] ,
    \pcnt_10[9] ,
    \pcnt_10[8] ,
    \pcnt_10[7] ,
    \pcnt_10[6] ,
    \pcnt_10[5] ,
    \pcnt_10[4] ,
    \pcnt_10[3] ,
    \pcnt_10[2] ,
    \pcnt_10[1] ,
    \pcnt_10[0] ,
    \u_pms9103_data/data_ready ,
    sys_clk,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input \pm1_cf1[15] ;
input \pm1_cf1[14] ;
input \pm1_cf1[13] ;
input \pm1_cf1[12] ;
input \pm1_cf1[11] ;
input \pm1_cf1[10] ;
input \pm1_cf1[9] ;
input \pm1_cf1[8] ;
input \pm1_cf1[7] ;
input \pm1_cf1[6] ;
input \pm1_cf1[5] ;
input \pm1_cf1[4] ;
input \pm1_cf1[3] ;
input \pm1_cf1[2] ;
input \pm1_cf1[1] ;
input \pm1_cf1[0] ;
input \pm25_cf1[15] ;
input \pm25_cf1[14] ;
input \pm25_cf1[13] ;
input \pm25_cf1[12] ;
input \pm25_cf1[11] ;
input \pm25_cf1[10] ;
input \pm25_cf1[9] ;
input \pm25_cf1[8] ;
input \pm25_cf1[7] ;
input \pm25_cf1[6] ;
input \pm25_cf1[5] ;
input \pm25_cf1[4] ;
input \pm25_cf1[3] ;
input \pm25_cf1[2] ;
input \pm25_cf1[1] ;
input \pm25_cf1[0] ;
input \pm10_cf1[15] ;
input \pm10_cf1[14] ;
input \pm10_cf1[13] ;
input \pm10_cf1[12] ;
input \pm10_cf1[11] ;
input \pm10_cf1[10] ;
input \pm10_cf1[9] ;
input \pm10_cf1[8] ;
input \pm10_cf1[7] ;
input \pm10_cf1[6] ;
input \pm10_cf1[5] ;
input \pm10_cf1[4] ;
input \pm10_cf1[3] ;
input \pm10_cf1[2] ;
input \pm10_cf1[1] ;
input \pm10_cf1[0] ;
input \pcnt_03[15] ;
input \pcnt_03[14] ;
input \pcnt_03[13] ;
input \pcnt_03[12] ;
input \pcnt_03[11] ;
input \pcnt_03[10] ;
input \pcnt_03[9] ;
input \pcnt_03[8] ;
input \pcnt_03[7] ;
input \pcnt_03[6] ;
input \pcnt_03[5] ;
input \pcnt_03[4] ;
input \pcnt_03[3] ;
input \pcnt_03[2] ;
input \pcnt_03[1] ;
input \pcnt_03[0] ;
input \pcnt_05[15] ;
input \pcnt_05[14] ;
input \pcnt_05[13] ;
input \pcnt_05[12] ;
input \pcnt_05[11] ;
input \pcnt_05[10] ;
input \pcnt_05[9] ;
input \pcnt_05[8] ;
input \pcnt_05[7] ;
input \pcnt_05[6] ;
input \pcnt_05[5] ;
input \pcnt_05[4] ;
input \pcnt_05[3] ;
input \pcnt_05[2] ;
input \pcnt_05[1] ;
input \pcnt_05[0] ;
input \pcnt_10[15] ;
input \pcnt_10[14] ;
input \pcnt_10[13] ;
input \pcnt_10[12] ;
input \pcnt_10[11] ;
input \pcnt_10[10] ;
input \pcnt_10[9] ;
input \pcnt_10[8] ;
input \pcnt_10[7] ;
input \pcnt_10[6] ;
input \pcnt_10[5] ;
input \pcnt_10[4] ;
input \pcnt_10[3] ;
input \pcnt_10[2] ;
input \pcnt_10[1] ;
input \pcnt_10[0] ;
input \u_pms9103_data/data_ready ;
input sys_clk;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire \pm1_cf1[15] ;
wire \pm1_cf1[14] ;
wire \pm1_cf1[13] ;
wire \pm1_cf1[12] ;
wire \pm1_cf1[11] ;
wire \pm1_cf1[10] ;
wire \pm1_cf1[9] ;
wire \pm1_cf1[8] ;
wire \pm1_cf1[7] ;
wire \pm1_cf1[6] ;
wire \pm1_cf1[5] ;
wire \pm1_cf1[4] ;
wire \pm1_cf1[3] ;
wire \pm1_cf1[2] ;
wire \pm1_cf1[1] ;
wire \pm1_cf1[0] ;
wire \pm25_cf1[15] ;
wire \pm25_cf1[14] ;
wire \pm25_cf1[13] ;
wire \pm25_cf1[12] ;
wire \pm25_cf1[11] ;
wire \pm25_cf1[10] ;
wire \pm25_cf1[9] ;
wire \pm25_cf1[8] ;
wire \pm25_cf1[7] ;
wire \pm25_cf1[6] ;
wire \pm25_cf1[5] ;
wire \pm25_cf1[4] ;
wire \pm25_cf1[3] ;
wire \pm25_cf1[2] ;
wire \pm25_cf1[1] ;
wire \pm25_cf1[0] ;
wire \pm10_cf1[15] ;
wire \pm10_cf1[14] ;
wire \pm10_cf1[13] ;
wire \pm10_cf1[12] ;
wire \pm10_cf1[11] ;
wire \pm10_cf1[10] ;
wire \pm10_cf1[9] ;
wire \pm10_cf1[8] ;
wire \pm10_cf1[7] ;
wire \pm10_cf1[6] ;
wire \pm10_cf1[5] ;
wire \pm10_cf1[4] ;
wire \pm10_cf1[3] ;
wire \pm10_cf1[2] ;
wire \pm10_cf1[1] ;
wire \pm10_cf1[0] ;
wire \pcnt_03[15] ;
wire \pcnt_03[14] ;
wire \pcnt_03[13] ;
wire \pcnt_03[12] ;
wire \pcnt_03[11] ;
wire \pcnt_03[10] ;
wire \pcnt_03[9] ;
wire \pcnt_03[8] ;
wire \pcnt_03[7] ;
wire \pcnt_03[6] ;
wire \pcnt_03[5] ;
wire \pcnt_03[4] ;
wire \pcnt_03[3] ;
wire \pcnt_03[2] ;
wire \pcnt_03[1] ;
wire \pcnt_03[0] ;
wire \pcnt_05[15] ;
wire \pcnt_05[14] ;
wire \pcnt_05[13] ;
wire \pcnt_05[12] ;
wire \pcnt_05[11] ;
wire \pcnt_05[10] ;
wire \pcnt_05[9] ;
wire \pcnt_05[8] ;
wire \pcnt_05[7] ;
wire \pcnt_05[6] ;
wire \pcnt_05[5] ;
wire \pcnt_05[4] ;
wire \pcnt_05[3] ;
wire \pcnt_05[2] ;
wire \pcnt_05[1] ;
wire \pcnt_05[0] ;
wire \pcnt_10[15] ;
wire \pcnt_10[14] ;
wire \pcnt_10[13] ;
wire \pcnt_10[12] ;
wire \pcnt_10[11] ;
wire \pcnt_10[10] ;
wire \pcnt_10[9] ;
wire \pcnt_10[8] ;
wire \pcnt_10[7] ;
wire \pcnt_10[6] ;
wire \pcnt_10[5] ;
wire \pcnt_10[4] ;
wire \pcnt_10[3] ;
wire \pcnt_10[2] ;
wire \pcnt_10[1] ;
wire \pcnt_10[0] ;
wire \u_pms9103_data/data_ready ;
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
    .trig0_i(\u_pms9103_data/data_ready ),
    .data_i({\pm1_cf1[15] ,\pm1_cf1[14] ,\pm1_cf1[13] ,\pm1_cf1[12] ,\pm1_cf1[11] ,\pm1_cf1[10] ,\pm1_cf1[9] ,\pm1_cf1[8] ,\pm1_cf1[7] ,\pm1_cf1[6] ,\pm1_cf1[5] ,\pm1_cf1[4] ,\pm1_cf1[3] ,\pm1_cf1[2] ,\pm1_cf1[1] ,\pm1_cf1[0] ,\pm25_cf1[15] ,\pm25_cf1[14] ,\pm25_cf1[13] ,\pm25_cf1[12] ,\pm25_cf1[11] ,\pm25_cf1[10] ,\pm25_cf1[9] ,\pm25_cf1[8] ,\pm25_cf1[7] ,\pm25_cf1[6] ,\pm25_cf1[5] ,\pm25_cf1[4] ,\pm25_cf1[3] ,\pm25_cf1[2] ,\pm25_cf1[1] ,\pm25_cf1[0] ,\pm10_cf1[15] ,\pm10_cf1[14] ,\pm10_cf1[13] ,\pm10_cf1[12] ,\pm10_cf1[11] ,\pm10_cf1[10] ,\pm10_cf1[9] ,\pm10_cf1[8] ,\pm10_cf1[7] ,\pm10_cf1[6] ,\pm10_cf1[5] ,\pm10_cf1[4] ,\pm10_cf1[3] ,\pm10_cf1[2] ,\pm10_cf1[1] ,\pm10_cf1[0] ,\pcnt_03[15] ,\pcnt_03[14] ,\pcnt_03[13] ,\pcnt_03[12] ,\pcnt_03[11] ,\pcnt_03[10] ,\pcnt_03[9] ,\pcnt_03[8] ,\pcnt_03[7] ,\pcnt_03[6] ,\pcnt_03[5] ,\pcnt_03[4] ,\pcnt_03[3] ,\pcnt_03[2] ,\pcnt_03[1] ,\pcnt_03[0] ,\pcnt_05[15] ,\pcnt_05[14] ,\pcnt_05[13] ,\pcnt_05[12] ,\pcnt_05[11] ,\pcnt_05[10] ,\pcnt_05[9] ,\pcnt_05[8] ,\pcnt_05[7] ,\pcnt_05[6] ,\pcnt_05[5] ,\pcnt_05[4] ,\pcnt_05[3] ,\pcnt_05[2] ,\pcnt_05[1] ,\pcnt_05[0] ,\pcnt_10[15] ,\pcnt_10[14] ,\pcnt_10[13] ,\pcnt_10[12] ,\pcnt_10[11] ,\pcnt_10[10] ,\pcnt_10[9] ,\pcnt_10[8] ,\pcnt_10[7] ,\pcnt_10[6] ,\pcnt_10[5] ,\pcnt_10[4] ,\pcnt_10[3] ,\pcnt_10[2] ,\pcnt_10[1] ,\pcnt_10[0] }),
    .clk_i(sys_clk)
);

endmodule
