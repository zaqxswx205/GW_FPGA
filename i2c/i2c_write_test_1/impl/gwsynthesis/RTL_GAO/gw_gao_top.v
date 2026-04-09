module gw_gao(
    \cur_state[5] ,
    \cur_state[4] ,
    \cur_state[3] ,
    \cur_state[2] ,
    \cur_state[1] ,
    \cur_state[0] ,
    \data[7] ,
    \data[6] ,
    \data[5] ,
    \data[4] ,
    \data[3] ,
    \data[2] ,
    \data[1] ,
    \data[0] ,
    \u_i2c_send_one_byte/cur_state[10] ,
    \u_i2c_send_one_byte/cur_state[9] ,
    \u_i2c_send_one_byte/cur_state[8] ,
    \u_i2c_send_one_byte/cur_state[7] ,
    \u_i2c_send_one_byte/cur_state[6] ,
    \u_i2c_send_one_byte/cur_state[5] ,
    \u_i2c_send_one_byte/cur_state[4] ,
    \u_i2c_send_one_byte/cur_state[3] ,
    \u_i2c_send_one_byte/cur_state[2] ,
    \u_i2c_send_one_byte/cur_state[1] ,
    \u_i2c_send_one_byte/cur_state[0] ,
    scl,
    sda,
    done,
    i2c_clk,
    start,
    need_release,
    sub_scl,
    sub_sda,
    sda_out,
    sda_in,
    sda_buf,
    \u_i2c_send_one_byte/pulse_cnt ,
    sys_clk,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input \cur_state[5] ;
input \cur_state[4] ;
input \cur_state[3] ;
input \cur_state[2] ;
input \cur_state[1] ;
input \cur_state[0] ;
input \data[7] ;
input \data[6] ;
input \data[5] ;
input \data[4] ;
input \data[3] ;
input \data[2] ;
input \data[1] ;
input \data[0] ;
input \u_i2c_send_one_byte/cur_state[10] ;
input \u_i2c_send_one_byte/cur_state[9] ;
input \u_i2c_send_one_byte/cur_state[8] ;
input \u_i2c_send_one_byte/cur_state[7] ;
input \u_i2c_send_one_byte/cur_state[6] ;
input \u_i2c_send_one_byte/cur_state[5] ;
input \u_i2c_send_one_byte/cur_state[4] ;
input \u_i2c_send_one_byte/cur_state[3] ;
input \u_i2c_send_one_byte/cur_state[2] ;
input \u_i2c_send_one_byte/cur_state[1] ;
input \u_i2c_send_one_byte/cur_state[0] ;
input scl;
input sda;
input done;
input i2c_clk;
input start;
input need_release;
input sub_scl;
input sub_sda;
input sda_out;
input sda_in;
input sda_buf;
input \u_i2c_send_one_byte/pulse_cnt ;
input sys_clk;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire \cur_state[5] ;
wire \cur_state[4] ;
wire \cur_state[3] ;
wire \cur_state[2] ;
wire \cur_state[1] ;
wire \cur_state[0] ;
wire \data[7] ;
wire \data[6] ;
wire \data[5] ;
wire \data[4] ;
wire \data[3] ;
wire \data[2] ;
wire \data[1] ;
wire \data[0] ;
wire \u_i2c_send_one_byte/cur_state[10] ;
wire \u_i2c_send_one_byte/cur_state[9] ;
wire \u_i2c_send_one_byte/cur_state[8] ;
wire \u_i2c_send_one_byte/cur_state[7] ;
wire \u_i2c_send_one_byte/cur_state[6] ;
wire \u_i2c_send_one_byte/cur_state[5] ;
wire \u_i2c_send_one_byte/cur_state[4] ;
wire \u_i2c_send_one_byte/cur_state[3] ;
wire \u_i2c_send_one_byte/cur_state[2] ;
wire \u_i2c_send_one_byte/cur_state[1] ;
wire \u_i2c_send_one_byte/cur_state[0] ;
wire scl;
wire sda;
wire done;
wire i2c_clk;
wire start;
wire need_release;
wire sub_scl;
wire sub_sda;
wire sda_out;
wire sda_in;
wire sda_buf;
wire \u_i2c_send_one_byte/pulse_cnt ;
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
    .trig0_i({\cur_state[5] ,\cur_state[4] ,\cur_state[3] ,\cur_state[2] ,\cur_state[1] ,\cur_state[0] }),
    .trig1_i(done),
    .trig2_i({\u_i2c_send_one_byte/cur_state[10] ,\u_i2c_send_one_byte/cur_state[9] ,\u_i2c_send_one_byte/cur_state[8] ,\u_i2c_send_one_byte/cur_state[7] ,\u_i2c_send_one_byte/cur_state[6] ,\u_i2c_send_one_byte/cur_state[5] ,\u_i2c_send_one_byte/cur_state[4] ,\u_i2c_send_one_byte/cur_state[3] ,\u_i2c_send_one_byte/cur_state[2] ,\u_i2c_send_one_byte/cur_state[1] ,\u_i2c_send_one_byte/cur_state[0] }),
    .data_i({\cur_state[5] ,\cur_state[4] ,\cur_state[3] ,\cur_state[2] ,\cur_state[1] ,\cur_state[0] ,\data[7] ,\data[6] ,\data[5] ,\data[4] ,\data[3] ,\data[2] ,\data[1] ,\data[0] ,\u_i2c_send_one_byte/cur_state[10] ,\u_i2c_send_one_byte/cur_state[9] ,\u_i2c_send_one_byte/cur_state[8] ,\u_i2c_send_one_byte/cur_state[7] ,\u_i2c_send_one_byte/cur_state[6] ,\u_i2c_send_one_byte/cur_state[5] ,\u_i2c_send_one_byte/cur_state[4] ,\u_i2c_send_one_byte/cur_state[3] ,\u_i2c_send_one_byte/cur_state[2] ,\u_i2c_send_one_byte/cur_state[1] ,\u_i2c_send_one_byte/cur_state[0] ,scl,sda,done,i2c_clk,start,need_release,sub_scl,sub_sda,sda_out,sda_in,sda_buf,\u_i2c_send_one_byte/pulse_cnt }),
    .clk_i(sys_clk)
);

endmodule
