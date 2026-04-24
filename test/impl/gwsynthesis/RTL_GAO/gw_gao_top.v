module gw_gao(
    \cur_state[4] ,
    \cur_state[3] ,
    \cur_state[2] ,
    \cur_state[1] ,
    \cur_state[0] ,
    \byte_cnt[7] ,
    \byte_cnt[6] ,
    \byte_cnt[5] ,
    \byte_cnt[4] ,
    \byte_cnt[3] ,
    \byte_cnt[2] ,
    \byte_cnt[1] ,
    \byte_cnt[0] ,
    done,
    sys_clk,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input \cur_state[4] ;
input \cur_state[3] ;
input \cur_state[2] ;
input \cur_state[1] ;
input \cur_state[0] ;
input \byte_cnt[7] ;
input \byte_cnt[6] ;
input \byte_cnt[5] ;
input \byte_cnt[4] ;
input \byte_cnt[3] ;
input \byte_cnt[2] ;
input \byte_cnt[1] ;
input \byte_cnt[0] ;
input done;
input sys_clk;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire \cur_state[4] ;
wire \cur_state[3] ;
wire \cur_state[2] ;
wire \cur_state[1] ;
wire \cur_state[0] ;
wire \byte_cnt[7] ;
wire \byte_cnt[6] ;
wire \byte_cnt[5] ;
wire \byte_cnt[4] ;
wire \byte_cnt[3] ;
wire \byte_cnt[2] ;
wire \byte_cnt[1] ;
wire \byte_cnt[0] ;
wire done;
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
    .trig0_i(done),
    .data_i({\cur_state[4] ,\cur_state[3] ,\cur_state[2] ,\cur_state[1] ,\cur_state[0] ,\byte_cnt[7] ,\byte_cnt[6] ,\byte_cnt[5] ,\byte_cnt[4] ,\byte_cnt[3] ,\byte_cnt[2] ,\byte_cnt[1] ,\byte_cnt[0] ,done}),
    .clk_i(sys_clk)
);

endmodule
