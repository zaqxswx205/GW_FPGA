module gw_gao(
    \cnt[25] ,
    \cnt[24] ,
    \cnt[23] ,
    \cnt[22] ,
    \cnt[21] ,
    \cnt[20] ,
    \cnt[19] ,
    \cnt[18] ,
    \cnt[17] ,
    \cnt[16] ,
    \cnt[15] ,
    \cnt[14] ,
    \cnt[13] ,
    \cnt[12] ,
    \cnt[11] ,
    \cnt[10] ,
    \cnt[9] ,
    \cnt[8] ,
    \cnt[7] ,
    \cnt[6] ,
    \cnt[5] ,
    \cnt[4] ,
    \cnt[3] ,
    \cnt[2] ,
    \cnt[1] ,
    \cnt[0] ,
    \u_mulit_tx_top/data_set_buf[47] ,
    \u_mulit_tx_top/data_set_buf[46] ,
    \u_mulit_tx_top/data_set_buf[45] ,
    \u_mulit_tx_top/data_set_buf[44] ,
    \u_mulit_tx_top/data_set_buf[43] ,
    \u_mulit_tx_top/data_set_buf[42] ,
    \u_mulit_tx_top/data_set_buf[41] ,
    \u_mulit_tx_top/data_set_buf[40] ,
    \u_mulit_tx_top/data_set_buf[39] ,
    \u_mulit_tx_top/data_set_buf[38] ,
    \u_mulit_tx_top/data_set_buf[37] ,
    \u_mulit_tx_top/data_set_buf[36] ,
    \u_mulit_tx_top/data_set_buf[35] ,
    \u_mulit_tx_top/data_set_buf[34] ,
    \u_mulit_tx_top/data_set_buf[33] ,
    \u_mulit_tx_top/data_set_buf[32] ,
    \u_mulit_tx_top/data_set_buf[31] ,
    \u_mulit_tx_top/data_set_buf[30] ,
    \u_mulit_tx_top/data_set_buf[29] ,
    \u_mulit_tx_top/data_set_buf[28] ,
    \u_mulit_tx_top/data_set_buf[27] ,
    \u_mulit_tx_top/data_set_buf[26] ,
    \u_mulit_tx_top/data_set_buf[25] ,
    \u_mulit_tx_top/data_set_buf[24] ,
    \u_mulit_tx_top/data_set_buf[23] ,
    \u_mulit_tx_top/data_set_buf[22] ,
    \u_mulit_tx_top/data_set_buf[21] ,
    \u_mulit_tx_top/data_set_buf[20] ,
    \u_mulit_tx_top/data_set_buf[19] ,
    \u_mulit_tx_top/data_set_buf[18] ,
    \u_mulit_tx_top/data_set_buf[17] ,
    \u_mulit_tx_top/data_set_buf[16] ,
    \u_mulit_tx_top/data_set_buf[15] ,
    \u_mulit_tx_top/data_set_buf[14] ,
    \u_mulit_tx_top/data_set_buf[13] ,
    \u_mulit_tx_top/data_set_buf[12] ,
    \u_mulit_tx_top/data_set_buf[11] ,
    \u_mulit_tx_top/data_set_buf[10] ,
    \u_mulit_tx_top/data_set_buf[9] ,
    \u_mulit_tx_top/data_set_buf[8] ,
    \u_mulit_tx_top/data_set_buf[7] ,
    \u_mulit_tx_top/data_set_buf[6] ,
    \u_mulit_tx_top/data_set_buf[5] ,
    \u_mulit_tx_top/data_set_buf[4] ,
    \u_mulit_tx_top/data_set_buf[3] ,
    \u_mulit_tx_top/data_set_buf[2] ,
    \u_mulit_tx_top/data_set_buf[1] ,
    \u_mulit_tx_top/data_set_buf[0] ,
    data_set,
    send_set,
    sys_clk,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input \cnt[25] ;
input \cnt[24] ;
input \cnt[23] ;
input \cnt[22] ;
input \cnt[21] ;
input \cnt[20] ;
input \cnt[19] ;
input \cnt[18] ;
input \cnt[17] ;
input \cnt[16] ;
input \cnt[15] ;
input \cnt[14] ;
input \cnt[13] ;
input \cnt[12] ;
input \cnt[11] ;
input \cnt[10] ;
input \cnt[9] ;
input \cnt[8] ;
input \cnt[7] ;
input \cnt[6] ;
input \cnt[5] ;
input \cnt[4] ;
input \cnt[3] ;
input \cnt[2] ;
input \cnt[1] ;
input \cnt[0] ;
input \u_mulit_tx_top/data_set_buf[47] ;
input \u_mulit_tx_top/data_set_buf[46] ;
input \u_mulit_tx_top/data_set_buf[45] ;
input \u_mulit_tx_top/data_set_buf[44] ;
input \u_mulit_tx_top/data_set_buf[43] ;
input \u_mulit_tx_top/data_set_buf[42] ;
input \u_mulit_tx_top/data_set_buf[41] ;
input \u_mulit_tx_top/data_set_buf[40] ;
input \u_mulit_tx_top/data_set_buf[39] ;
input \u_mulit_tx_top/data_set_buf[38] ;
input \u_mulit_tx_top/data_set_buf[37] ;
input \u_mulit_tx_top/data_set_buf[36] ;
input \u_mulit_tx_top/data_set_buf[35] ;
input \u_mulit_tx_top/data_set_buf[34] ;
input \u_mulit_tx_top/data_set_buf[33] ;
input \u_mulit_tx_top/data_set_buf[32] ;
input \u_mulit_tx_top/data_set_buf[31] ;
input \u_mulit_tx_top/data_set_buf[30] ;
input \u_mulit_tx_top/data_set_buf[29] ;
input \u_mulit_tx_top/data_set_buf[28] ;
input \u_mulit_tx_top/data_set_buf[27] ;
input \u_mulit_tx_top/data_set_buf[26] ;
input \u_mulit_tx_top/data_set_buf[25] ;
input \u_mulit_tx_top/data_set_buf[24] ;
input \u_mulit_tx_top/data_set_buf[23] ;
input \u_mulit_tx_top/data_set_buf[22] ;
input \u_mulit_tx_top/data_set_buf[21] ;
input \u_mulit_tx_top/data_set_buf[20] ;
input \u_mulit_tx_top/data_set_buf[19] ;
input \u_mulit_tx_top/data_set_buf[18] ;
input \u_mulit_tx_top/data_set_buf[17] ;
input \u_mulit_tx_top/data_set_buf[16] ;
input \u_mulit_tx_top/data_set_buf[15] ;
input \u_mulit_tx_top/data_set_buf[14] ;
input \u_mulit_tx_top/data_set_buf[13] ;
input \u_mulit_tx_top/data_set_buf[12] ;
input \u_mulit_tx_top/data_set_buf[11] ;
input \u_mulit_tx_top/data_set_buf[10] ;
input \u_mulit_tx_top/data_set_buf[9] ;
input \u_mulit_tx_top/data_set_buf[8] ;
input \u_mulit_tx_top/data_set_buf[7] ;
input \u_mulit_tx_top/data_set_buf[6] ;
input \u_mulit_tx_top/data_set_buf[5] ;
input \u_mulit_tx_top/data_set_buf[4] ;
input \u_mulit_tx_top/data_set_buf[3] ;
input \u_mulit_tx_top/data_set_buf[2] ;
input \u_mulit_tx_top/data_set_buf[1] ;
input \u_mulit_tx_top/data_set_buf[0] ;
input data_set;
input send_set;
input sys_clk;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire \cnt[25] ;
wire \cnt[24] ;
wire \cnt[23] ;
wire \cnt[22] ;
wire \cnt[21] ;
wire \cnt[20] ;
wire \cnt[19] ;
wire \cnt[18] ;
wire \cnt[17] ;
wire \cnt[16] ;
wire \cnt[15] ;
wire \cnt[14] ;
wire \cnt[13] ;
wire \cnt[12] ;
wire \cnt[11] ;
wire \cnt[10] ;
wire \cnt[9] ;
wire \cnt[8] ;
wire \cnt[7] ;
wire \cnt[6] ;
wire \cnt[5] ;
wire \cnt[4] ;
wire \cnt[3] ;
wire \cnt[2] ;
wire \cnt[1] ;
wire \cnt[0] ;
wire \u_mulit_tx_top/data_set_buf[47] ;
wire \u_mulit_tx_top/data_set_buf[46] ;
wire \u_mulit_tx_top/data_set_buf[45] ;
wire \u_mulit_tx_top/data_set_buf[44] ;
wire \u_mulit_tx_top/data_set_buf[43] ;
wire \u_mulit_tx_top/data_set_buf[42] ;
wire \u_mulit_tx_top/data_set_buf[41] ;
wire \u_mulit_tx_top/data_set_buf[40] ;
wire \u_mulit_tx_top/data_set_buf[39] ;
wire \u_mulit_tx_top/data_set_buf[38] ;
wire \u_mulit_tx_top/data_set_buf[37] ;
wire \u_mulit_tx_top/data_set_buf[36] ;
wire \u_mulit_tx_top/data_set_buf[35] ;
wire \u_mulit_tx_top/data_set_buf[34] ;
wire \u_mulit_tx_top/data_set_buf[33] ;
wire \u_mulit_tx_top/data_set_buf[32] ;
wire \u_mulit_tx_top/data_set_buf[31] ;
wire \u_mulit_tx_top/data_set_buf[30] ;
wire \u_mulit_tx_top/data_set_buf[29] ;
wire \u_mulit_tx_top/data_set_buf[28] ;
wire \u_mulit_tx_top/data_set_buf[27] ;
wire \u_mulit_tx_top/data_set_buf[26] ;
wire \u_mulit_tx_top/data_set_buf[25] ;
wire \u_mulit_tx_top/data_set_buf[24] ;
wire \u_mulit_tx_top/data_set_buf[23] ;
wire \u_mulit_tx_top/data_set_buf[22] ;
wire \u_mulit_tx_top/data_set_buf[21] ;
wire \u_mulit_tx_top/data_set_buf[20] ;
wire \u_mulit_tx_top/data_set_buf[19] ;
wire \u_mulit_tx_top/data_set_buf[18] ;
wire \u_mulit_tx_top/data_set_buf[17] ;
wire \u_mulit_tx_top/data_set_buf[16] ;
wire \u_mulit_tx_top/data_set_buf[15] ;
wire \u_mulit_tx_top/data_set_buf[14] ;
wire \u_mulit_tx_top/data_set_buf[13] ;
wire \u_mulit_tx_top/data_set_buf[12] ;
wire \u_mulit_tx_top/data_set_buf[11] ;
wire \u_mulit_tx_top/data_set_buf[10] ;
wire \u_mulit_tx_top/data_set_buf[9] ;
wire \u_mulit_tx_top/data_set_buf[8] ;
wire \u_mulit_tx_top/data_set_buf[7] ;
wire \u_mulit_tx_top/data_set_buf[6] ;
wire \u_mulit_tx_top/data_set_buf[5] ;
wire \u_mulit_tx_top/data_set_buf[4] ;
wire \u_mulit_tx_top/data_set_buf[3] ;
wire \u_mulit_tx_top/data_set_buf[2] ;
wire \u_mulit_tx_top/data_set_buf[1] ;
wire \u_mulit_tx_top/data_set_buf[0] ;
wire data_set;
wire send_set;
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
    .trig0_i(data_set),
    .trig1_i(send_set),
    .trig2_i({\cnt[25] ,\cnt[24] ,\cnt[23] ,\cnt[22] ,\cnt[21] ,\cnt[20] ,\cnt[19] ,\cnt[18] ,\cnt[17] ,\cnt[16] ,\cnt[15] ,\cnt[14] ,\cnt[13] ,\cnt[12] ,\cnt[11] ,\cnt[10] ,\cnt[9] ,\cnt[8] ,\cnt[7] ,\cnt[6] ,\cnt[5] ,\cnt[4] ,\cnt[3] ,\cnt[2] ,\cnt[1] ,\cnt[0] }),
    .data_i({\cnt[25] ,\cnt[24] ,\cnt[23] ,\cnt[22] ,\cnt[21] ,\cnt[20] ,\cnt[19] ,\cnt[18] ,\cnt[17] ,\cnt[16] ,\cnt[15] ,\cnt[14] ,\cnt[13] ,\cnt[12] ,\cnt[11] ,\cnt[10] ,\cnt[9] ,\cnt[8] ,\cnt[7] ,\cnt[6] ,\cnt[5] ,\cnt[4] ,\cnt[3] ,\cnt[2] ,\cnt[1] ,\cnt[0] ,\u_mulit_tx_top/data_set_buf[47] ,\u_mulit_tx_top/data_set_buf[46] ,\u_mulit_tx_top/data_set_buf[45] ,\u_mulit_tx_top/data_set_buf[44] ,\u_mulit_tx_top/data_set_buf[43] ,\u_mulit_tx_top/data_set_buf[42] ,\u_mulit_tx_top/data_set_buf[41] ,\u_mulit_tx_top/data_set_buf[40] ,\u_mulit_tx_top/data_set_buf[39] ,\u_mulit_tx_top/data_set_buf[38] ,\u_mulit_tx_top/data_set_buf[37] ,\u_mulit_tx_top/data_set_buf[36] ,\u_mulit_tx_top/data_set_buf[35] ,\u_mulit_tx_top/data_set_buf[34] ,\u_mulit_tx_top/data_set_buf[33] ,\u_mulit_tx_top/data_set_buf[32] ,\u_mulit_tx_top/data_set_buf[31] ,\u_mulit_tx_top/data_set_buf[30] ,\u_mulit_tx_top/data_set_buf[29] ,\u_mulit_tx_top/data_set_buf[28] ,\u_mulit_tx_top/data_set_buf[27] ,\u_mulit_tx_top/data_set_buf[26] ,\u_mulit_tx_top/data_set_buf[25] ,\u_mulit_tx_top/data_set_buf[24] ,\u_mulit_tx_top/data_set_buf[23] ,\u_mulit_tx_top/data_set_buf[22] ,\u_mulit_tx_top/data_set_buf[21] ,\u_mulit_tx_top/data_set_buf[20] ,\u_mulit_tx_top/data_set_buf[19] ,\u_mulit_tx_top/data_set_buf[18] ,\u_mulit_tx_top/data_set_buf[17] ,\u_mulit_tx_top/data_set_buf[16] ,\u_mulit_tx_top/data_set_buf[15] ,\u_mulit_tx_top/data_set_buf[14] ,\u_mulit_tx_top/data_set_buf[13] ,\u_mulit_tx_top/data_set_buf[12] ,\u_mulit_tx_top/data_set_buf[11] ,\u_mulit_tx_top/data_set_buf[10] ,\u_mulit_tx_top/data_set_buf[9] ,\u_mulit_tx_top/data_set_buf[8] ,\u_mulit_tx_top/data_set_buf[7] ,\u_mulit_tx_top/data_set_buf[6] ,\u_mulit_tx_top/data_set_buf[5] ,\u_mulit_tx_top/data_set_buf[4] ,\u_mulit_tx_top/data_set_buf[3] ,\u_mulit_tx_top/data_set_buf[2] ,\u_mulit_tx_top/data_set_buf[1] ,\u_mulit_tx_top/data_set_buf[0] ,data_set,send_set}),
    .clk_i(sys_clk)
);

endmodule
