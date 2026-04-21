module gw_gao(
    \O_RDATA[7] ,
    \O_RDATA[6] ,
    \O_RDATA[5] ,
    \O_RDATA[4] ,
    \O_RDATA[3] ,
    \O_RDATA[2] ,
    \O_RDATA[1] ,
    \O_RDATA[0] ,
    SDA,
    SCL,
    i2c_clk,
    O_IIC_INT,
    sys_clk,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input \O_RDATA[7] ;
input \O_RDATA[6] ;
input \O_RDATA[5] ;
input \O_RDATA[4] ;
input \O_RDATA[3] ;
input \O_RDATA[2] ;
input \O_RDATA[1] ;
input \O_RDATA[0] ;
input SDA;
input SCL;
input i2c_clk;
input O_IIC_INT;
input sys_clk;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire \O_RDATA[7] ;
wire \O_RDATA[6] ;
wire \O_RDATA[5] ;
wire \O_RDATA[4] ;
wire \O_RDATA[3] ;
wire \O_RDATA[2] ;
wire \O_RDATA[1] ;
wire \O_RDATA[0] ;
wire SDA;
wire SCL;
wire i2c_clk;
wire O_IIC_INT;
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
    .trig0_i(O_IIC_INT),
    .data_i({\O_RDATA[7] ,\O_RDATA[6] ,\O_RDATA[5] ,\O_RDATA[4] ,\O_RDATA[3] ,\O_RDATA[2] ,\O_RDATA[1] ,\O_RDATA[0] ,SDA,SCL,i2c_clk,O_IIC_INT}),
    .clk_i(sys_clk)
);

endmodule
