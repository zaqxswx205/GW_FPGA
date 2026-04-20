module gw_gao(
    \u_i2c_send_single_command/cur_state[5] ,
    \u_i2c_send_single_command/cur_state[4] ,
    \u_i2c_send_single_command/cur_state[3] ,
    \u_i2c_send_single_command/cur_state[2] ,
    \u_i2c_send_single_command/cur_state[1] ,
    \u_i2c_send_single_command/cur_state[0] ,
    \u_i2c_send_single_command/data[7] ,
    \u_i2c_send_single_command/data[6] ,
    \u_i2c_send_single_command/data[5] ,
    \u_i2c_send_single_command/data[4] ,
    \u_i2c_send_single_command/data[3] ,
    \u_i2c_send_single_command/data[2] ,
    \u_i2c_send_single_command/data[1] ,
    \u_i2c_send_single_command/data[0] ,
    scl,
    sda,
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
    start,
    done,
    busy,
    \u_i2c_send_single_command/pulse_cnt[3] ,
    \u_i2c_send_single_command/pulse_cnt[2] ,
    \u_i2c_send_single_command/pulse_cnt[1] ,
    \u_i2c_send_single_command/pulse_cnt[0] ,
    \u_i2c_send_single_command/scl_buf ,
    \u_i2c_send_single_command/sda_buf ,
    sys_clk,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input \u_i2c_send_single_command/cur_state[5] ;
input \u_i2c_send_single_command/cur_state[4] ;
input \u_i2c_send_single_command/cur_state[3] ;
input \u_i2c_send_single_command/cur_state[2] ;
input \u_i2c_send_single_command/cur_state[1] ;
input \u_i2c_send_single_command/cur_state[0] ;
input \u_i2c_send_single_command/data[7] ;
input \u_i2c_send_single_command/data[6] ;
input \u_i2c_send_single_command/data[5] ;
input \u_i2c_send_single_command/data[4] ;
input \u_i2c_send_single_command/data[3] ;
input \u_i2c_send_single_command/data[2] ;
input \u_i2c_send_single_command/data[1] ;
input \u_i2c_send_single_command/data[0] ;
input scl;
input sda;
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
input start;
input done;
input busy;
input \u_i2c_send_single_command/pulse_cnt[3] ;
input \u_i2c_send_single_command/pulse_cnt[2] ;
input \u_i2c_send_single_command/pulse_cnt[1] ;
input \u_i2c_send_single_command/pulse_cnt[0] ;
input \u_i2c_send_single_command/scl_buf ;
input \u_i2c_send_single_command/sda_buf ;
input sys_clk;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire \u_i2c_send_single_command/cur_state[5] ;
wire \u_i2c_send_single_command/cur_state[4] ;
wire \u_i2c_send_single_command/cur_state[3] ;
wire \u_i2c_send_single_command/cur_state[2] ;
wire \u_i2c_send_single_command/cur_state[1] ;
wire \u_i2c_send_single_command/cur_state[0] ;
wire \u_i2c_send_single_command/data[7] ;
wire \u_i2c_send_single_command/data[6] ;
wire \u_i2c_send_single_command/data[5] ;
wire \u_i2c_send_single_command/data[4] ;
wire \u_i2c_send_single_command/data[3] ;
wire \u_i2c_send_single_command/data[2] ;
wire \u_i2c_send_single_command/data[1] ;
wire \u_i2c_send_single_command/data[0] ;
wire scl;
wire sda;
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
wire start;
wire done;
wire busy;
wire \u_i2c_send_single_command/pulse_cnt[3] ;
wire \u_i2c_send_single_command/pulse_cnt[2] ;
wire \u_i2c_send_single_command/pulse_cnt[1] ;
wire \u_i2c_send_single_command/pulse_cnt[0] ;
wire \u_i2c_send_single_command/scl_buf ;
wire \u_i2c_send_single_command/sda_buf ;
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
    .trig1_i({\u_i2c_send_single_command/cur_state[5] ,\u_i2c_send_single_command/cur_state[4] ,\u_i2c_send_single_command/cur_state[3] ,\u_i2c_send_single_command/cur_state[2] ,\u_i2c_send_single_command/cur_state[1] ,\u_i2c_send_single_command/cur_state[0] }),
    .trig2_i({\u_i2c_send_single_command/pulse_cnt[3] ,\u_i2c_send_single_command/pulse_cnt[2] ,\u_i2c_send_single_command/pulse_cnt[1] ,\u_i2c_send_single_command/pulse_cnt[0] }),
    .data_i({\u_i2c_send_single_command/cur_state[5] ,\u_i2c_send_single_command/cur_state[4] ,\u_i2c_send_single_command/cur_state[3] ,\u_i2c_send_single_command/cur_state[2] ,\u_i2c_send_single_command/cur_state[1] ,\u_i2c_send_single_command/cur_state[0] ,\u_i2c_send_single_command/data[7] ,\u_i2c_send_single_command/data[6] ,\u_i2c_send_single_command/data[5] ,\u_i2c_send_single_command/data[4] ,\u_i2c_send_single_command/data[3] ,\u_i2c_send_single_command/data[2] ,\u_i2c_send_single_command/data[1] ,\u_i2c_send_single_command/data[0] ,scl,sda,\cnt[11] ,\cnt[10] ,\cnt[9] ,\cnt[8] ,\cnt[7] ,\cnt[6] ,\cnt[5] ,\cnt[4] ,\cnt[3] ,\cnt[2] ,\cnt[1] ,\cnt[0] ,start,done,busy,\u_i2c_send_single_command/pulse_cnt[3] ,\u_i2c_send_single_command/pulse_cnt[2] ,\u_i2c_send_single_command/pulse_cnt[1] ,\u_i2c_send_single_command/pulse_cnt[0] ,\u_i2c_send_single_command/scl_buf ,\u_i2c_send_single_command/sda_buf }),
    .clk_i(sys_clk)
);

endmodule
