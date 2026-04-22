module gw_gao(
    \cur_state[3] ,
    \cur_state[2] ,
    \cur_state[1] ,
    \cur_state[0] ,
    \u_i2c_driver/cur_state[8] ,
    \u_i2c_driver/cur_state[7] ,
    \u_i2c_driver/cur_state[6] ,
    \u_i2c_driver/cur_state[5] ,
    \u_i2c_driver/cur_state[4] ,
    \u_i2c_driver/cur_state[3] ,
    \u_i2c_driver/cur_state[2] ,
    \u_i2c_driver/cur_state[1] ,
    \u_i2c_driver/cur_state[0] ,
    \length[7] ,
    \length[6] ,
    \length[5] ,
    \length[4] ,
    \length[3] ,
    \length[2] ,
    \length[1] ,
    \length[0] ,
    \command[7] ,
    \command[6] ,
    \command[5] ,
    \command[4] ,
    \command[3] ,
    \command[2] ,
    \command[1] ,
    \command[0] ,
    i2c_done,
    sys_clk,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input \cur_state[3] ;
input \cur_state[2] ;
input \cur_state[1] ;
input \cur_state[0] ;
input \u_i2c_driver/cur_state[8] ;
input \u_i2c_driver/cur_state[7] ;
input \u_i2c_driver/cur_state[6] ;
input \u_i2c_driver/cur_state[5] ;
input \u_i2c_driver/cur_state[4] ;
input \u_i2c_driver/cur_state[3] ;
input \u_i2c_driver/cur_state[2] ;
input \u_i2c_driver/cur_state[1] ;
input \u_i2c_driver/cur_state[0] ;
input \length[7] ;
input \length[6] ;
input \length[5] ;
input \length[4] ;
input \length[3] ;
input \length[2] ;
input \length[1] ;
input \length[0] ;
input \command[7] ;
input \command[6] ;
input \command[5] ;
input \command[4] ;
input \command[3] ;
input \command[2] ;
input \command[1] ;
input \command[0] ;
input i2c_done;
input sys_clk;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire \cur_state[3] ;
wire \cur_state[2] ;
wire \cur_state[1] ;
wire \cur_state[0] ;
wire \u_i2c_driver/cur_state[8] ;
wire \u_i2c_driver/cur_state[7] ;
wire \u_i2c_driver/cur_state[6] ;
wire \u_i2c_driver/cur_state[5] ;
wire \u_i2c_driver/cur_state[4] ;
wire \u_i2c_driver/cur_state[3] ;
wire \u_i2c_driver/cur_state[2] ;
wire \u_i2c_driver/cur_state[1] ;
wire \u_i2c_driver/cur_state[0] ;
wire \length[7] ;
wire \length[6] ;
wire \length[5] ;
wire \length[4] ;
wire \length[3] ;
wire \length[2] ;
wire \length[1] ;
wire \length[0] ;
wire \command[7] ;
wire \command[6] ;
wire \command[5] ;
wire \command[4] ;
wire \command[3] ;
wire \command[2] ;
wire \command[1] ;
wire \command[0] ;
wire i2c_done;
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
    .trig0_i(i2c_done),
    .trig1_i({\cur_state[3] ,\cur_state[2] ,\cur_state[1] ,\cur_state[0] }),
    .data_i({\cur_state[3] ,\cur_state[2] ,\cur_state[1] ,\cur_state[0] ,\u_i2c_driver/cur_state[8] ,\u_i2c_driver/cur_state[7] ,\u_i2c_driver/cur_state[6] ,\u_i2c_driver/cur_state[5] ,\u_i2c_driver/cur_state[4] ,\u_i2c_driver/cur_state[3] ,\u_i2c_driver/cur_state[2] ,\u_i2c_driver/cur_state[1] ,\u_i2c_driver/cur_state[0] ,\length[7] ,\length[6] ,\length[5] ,\length[4] ,\length[3] ,\length[2] ,\length[1] ,\length[0] ,\command[7] ,\command[6] ,\command[5] ,\command[4] ,\command[3] ,\command[2] ,\command[1] ,\command[0] ,i2c_done}),
    .clk_i(sys_clk)
);

endmodule
