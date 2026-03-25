module gw_gao(
    \rx_state[3] ,
    \rx_state[2] ,
    \rx_state[1] ,
    \rx_state[0] ,
    rx_done,
    rx_err,
    \rx_data[7] ,
    \rx_data[6] ,
    \rx_data[5] ,
    \rx_data[4] ,
    \rx_data[3] ,
    \rx_data[2] ,
    \rx_data[1] ,
    \rx_data[0] ,
    \rx_cnt[8] ,
    \rx_cnt[7] ,
    \rx_cnt[6] ,
    \rx_cnt[5] ,
    \rx_cnt[4] ,
    \rx_cnt[3] ,
    \rx_cnt[2] ,
    \rx_cnt[1] ,
    \rx_cnt[0] ,
    \bit_cnt[3] ,
    \bit_cnt[2] ,
    \bit_cnt[1] ,
    \bit_cnt[0] ,
    \sample_cnt[3] ,
    \sample_cnt[2] ,
    \sample_cnt[1] ,
    \sample_cnt[0] ,
    rx_syn,
    rx_clk,
    sys_clk,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input \rx_state[3] ;
input \rx_state[2] ;
input \rx_state[1] ;
input \rx_state[0] ;
input rx_done;
input rx_err;
input \rx_data[7] ;
input \rx_data[6] ;
input \rx_data[5] ;
input \rx_data[4] ;
input \rx_data[3] ;
input \rx_data[2] ;
input \rx_data[1] ;
input \rx_data[0] ;
input \rx_cnt[8] ;
input \rx_cnt[7] ;
input \rx_cnt[6] ;
input \rx_cnt[5] ;
input \rx_cnt[4] ;
input \rx_cnt[3] ;
input \rx_cnt[2] ;
input \rx_cnt[1] ;
input \rx_cnt[0] ;
input \bit_cnt[3] ;
input \bit_cnt[2] ;
input \bit_cnt[1] ;
input \bit_cnt[0] ;
input \sample_cnt[3] ;
input \sample_cnt[2] ;
input \sample_cnt[1] ;
input \sample_cnt[0] ;
input rx_syn;
input rx_clk;
input sys_clk;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire \rx_state[3] ;
wire \rx_state[2] ;
wire \rx_state[1] ;
wire \rx_state[0] ;
wire rx_done;
wire rx_err;
wire \rx_data[7] ;
wire \rx_data[6] ;
wire \rx_data[5] ;
wire \rx_data[4] ;
wire \rx_data[3] ;
wire \rx_data[2] ;
wire \rx_data[1] ;
wire \rx_data[0] ;
wire \rx_cnt[8] ;
wire \rx_cnt[7] ;
wire \rx_cnt[6] ;
wire \rx_cnt[5] ;
wire \rx_cnt[4] ;
wire \rx_cnt[3] ;
wire \rx_cnt[2] ;
wire \rx_cnt[1] ;
wire \rx_cnt[0] ;
wire \bit_cnt[3] ;
wire \bit_cnt[2] ;
wire \bit_cnt[1] ;
wire \bit_cnt[0] ;
wire \sample_cnt[3] ;
wire \sample_cnt[2] ;
wire \sample_cnt[1] ;
wire \sample_cnt[0] ;
wire rx_syn;
wire rx_clk;
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
    .trig0_i({\rx_state[3] ,\rx_state[2] ,\rx_state[1] ,\rx_state[0] }),
    .trig1_i(rx_done),
    .trig2_i(rx_err),
    .trig3_i({\rx_data[7] ,\rx_data[6] ,\rx_data[5] ,\rx_data[4] ,\rx_data[3] ,\rx_data[2] ,\rx_data[1] ,\rx_data[0] }),
    .data_i({\rx_state[3] ,\rx_state[2] ,\rx_state[1] ,\rx_state[0] ,rx_done,rx_err,\rx_data[7] ,\rx_data[6] ,\rx_data[5] ,\rx_data[4] ,\rx_data[3] ,\rx_data[2] ,\rx_data[1] ,\rx_data[0] ,\rx_cnt[8] ,\rx_cnt[7] ,\rx_cnt[6] ,\rx_cnt[5] ,\rx_cnt[4] ,\rx_cnt[3] ,\rx_cnt[2] ,\rx_cnt[1] ,\rx_cnt[0] ,\bit_cnt[3] ,\bit_cnt[2] ,\bit_cnt[1] ,\bit_cnt[0] ,\sample_cnt[3] ,\sample_cnt[2] ,\sample_cnt[1] ,\sample_cnt[0] ,rx_syn,rx_clk}),
    .clk_i(sys_clk)
);

endmodule
