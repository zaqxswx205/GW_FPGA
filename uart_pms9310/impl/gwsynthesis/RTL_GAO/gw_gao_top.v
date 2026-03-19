module gw_gao(
    \u_fifo_top/u_fifo/wr_data[7] ,
    \u_fifo_top/u_fifo/wr_data[6] ,
    \u_fifo_top/u_fifo/wr_data[5] ,
    \u_fifo_top/u_fifo/wr_data[4] ,
    \u_fifo_top/u_fifo/wr_data[3] ,
    \u_fifo_top/u_fifo/wr_data[2] ,
    \u_fifo_top/u_fifo/wr_data[1] ,
    \u_fifo_top/u_fifo/wr_data[0] ,
    \u_fifo_top/u_fifo/rd_data[7] ,
    \u_fifo_top/u_fifo/rd_data[6] ,
    \u_fifo_top/u_fifo/rd_data[5] ,
    \u_fifo_top/u_fifo/rd_data[4] ,
    \u_fifo_top/u_fifo/rd_data[3] ,
    \u_fifo_top/u_fifo/rd_data[2] ,
    \u_fifo_top/u_fifo/rd_data[1] ,
    \u_fifo_top/u_fifo/rd_data[0] ,
    \u_fifo_top/u_fifo/wr_addr[7] ,
    \u_fifo_top/u_fifo/wr_addr[6] ,
    \u_fifo_top/u_fifo/wr_addr[5] ,
    \u_fifo_top/u_fifo/wr_addr[4] ,
    \u_fifo_top/u_fifo/wr_addr[3] ,
    \u_fifo_top/u_fifo/wr_addr[2] ,
    \u_fifo_top/u_fifo/wr_addr[1] ,
    \u_fifo_top/u_fifo/wr_addr[0] ,
    \u_fifo_top/u_fifo/rd_addr[7] ,
    \u_fifo_top/u_fifo/rd_addr[6] ,
    \u_fifo_top/u_fifo/rd_addr[5] ,
    \u_fifo_top/u_fifo/rd_addr[4] ,
    \u_fifo_top/u_fifo/rd_addr[3] ,
    \u_fifo_top/u_fifo/rd_addr[2] ,
    \u_fifo_top/u_fifo/rd_addr[1] ,
    \u_fifo_top/u_fifo/rd_addr[0] ,
    \u_fifo_top/frame_head_state[1] ,
    \u_fifo_top/frame_head_state[0] ,
    \u_fifo_top/u_fifo/phase ,
    \u_fifo_top/u_fifo/wr_en ,
    \u_fifo_top/u_uart_rx/rx_done ,
    \u_fifo_top/head_valid ,
    phase,
    tx_set,
    \u_fifo_top/phase ,
    sys_clk,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input \u_fifo_top/u_fifo/wr_data[7] ;
input \u_fifo_top/u_fifo/wr_data[6] ;
input \u_fifo_top/u_fifo/wr_data[5] ;
input \u_fifo_top/u_fifo/wr_data[4] ;
input \u_fifo_top/u_fifo/wr_data[3] ;
input \u_fifo_top/u_fifo/wr_data[2] ;
input \u_fifo_top/u_fifo/wr_data[1] ;
input \u_fifo_top/u_fifo/wr_data[0] ;
input \u_fifo_top/u_fifo/rd_data[7] ;
input \u_fifo_top/u_fifo/rd_data[6] ;
input \u_fifo_top/u_fifo/rd_data[5] ;
input \u_fifo_top/u_fifo/rd_data[4] ;
input \u_fifo_top/u_fifo/rd_data[3] ;
input \u_fifo_top/u_fifo/rd_data[2] ;
input \u_fifo_top/u_fifo/rd_data[1] ;
input \u_fifo_top/u_fifo/rd_data[0] ;
input \u_fifo_top/u_fifo/wr_addr[7] ;
input \u_fifo_top/u_fifo/wr_addr[6] ;
input \u_fifo_top/u_fifo/wr_addr[5] ;
input \u_fifo_top/u_fifo/wr_addr[4] ;
input \u_fifo_top/u_fifo/wr_addr[3] ;
input \u_fifo_top/u_fifo/wr_addr[2] ;
input \u_fifo_top/u_fifo/wr_addr[1] ;
input \u_fifo_top/u_fifo/wr_addr[0] ;
input \u_fifo_top/u_fifo/rd_addr[7] ;
input \u_fifo_top/u_fifo/rd_addr[6] ;
input \u_fifo_top/u_fifo/rd_addr[5] ;
input \u_fifo_top/u_fifo/rd_addr[4] ;
input \u_fifo_top/u_fifo/rd_addr[3] ;
input \u_fifo_top/u_fifo/rd_addr[2] ;
input \u_fifo_top/u_fifo/rd_addr[1] ;
input \u_fifo_top/u_fifo/rd_addr[0] ;
input \u_fifo_top/frame_head_state[1] ;
input \u_fifo_top/frame_head_state[0] ;
input \u_fifo_top/u_fifo/phase ;
input \u_fifo_top/u_fifo/wr_en ;
input \u_fifo_top/u_uart_rx/rx_done ;
input \u_fifo_top/head_valid ;
input phase;
input tx_set;
input \u_fifo_top/phase ;
input sys_clk;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire \u_fifo_top/u_fifo/wr_data[7] ;
wire \u_fifo_top/u_fifo/wr_data[6] ;
wire \u_fifo_top/u_fifo/wr_data[5] ;
wire \u_fifo_top/u_fifo/wr_data[4] ;
wire \u_fifo_top/u_fifo/wr_data[3] ;
wire \u_fifo_top/u_fifo/wr_data[2] ;
wire \u_fifo_top/u_fifo/wr_data[1] ;
wire \u_fifo_top/u_fifo/wr_data[0] ;
wire \u_fifo_top/u_fifo/rd_data[7] ;
wire \u_fifo_top/u_fifo/rd_data[6] ;
wire \u_fifo_top/u_fifo/rd_data[5] ;
wire \u_fifo_top/u_fifo/rd_data[4] ;
wire \u_fifo_top/u_fifo/rd_data[3] ;
wire \u_fifo_top/u_fifo/rd_data[2] ;
wire \u_fifo_top/u_fifo/rd_data[1] ;
wire \u_fifo_top/u_fifo/rd_data[0] ;
wire \u_fifo_top/u_fifo/wr_addr[7] ;
wire \u_fifo_top/u_fifo/wr_addr[6] ;
wire \u_fifo_top/u_fifo/wr_addr[5] ;
wire \u_fifo_top/u_fifo/wr_addr[4] ;
wire \u_fifo_top/u_fifo/wr_addr[3] ;
wire \u_fifo_top/u_fifo/wr_addr[2] ;
wire \u_fifo_top/u_fifo/wr_addr[1] ;
wire \u_fifo_top/u_fifo/wr_addr[0] ;
wire \u_fifo_top/u_fifo/rd_addr[7] ;
wire \u_fifo_top/u_fifo/rd_addr[6] ;
wire \u_fifo_top/u_fifo/rd_addr[5] ;
wire \u_fifo_top/u_fifo/rd_addr[4] ;
wire \u_fifo_top/u_fifo/rd_addr[3] ;
wire \u_fifo_top/u_fifo/rd_addr[2] ;
wire \u_fifo_top/u_fifo/rd_addr[1] ;
wire \u_fifo_top/u_fifo/rd_addr[0] ;
wire \u_fifo_top/frame_head_state[1] ;
wire \u_fifo_top/frame_head_state[0] ;
wire \u_fifo_top/u_fifo/phase ;
wire \u_fifo_top/u_fifo/wr_en ;
wire \u_fifo_top/u_uart_rx/rx_done ;
wire \u_fifo_top/head_valid ;
wire phase;
wire tx_set;
wire \u_fifo_top/phase ;
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
    .trig0_i(\u_fifo_top/phase ),
    .trig1_i(tx_set),
    .trig2_i({\u_fifo_top/frame_head_state[1] ,\u_fifo_top/frame_head_state[0] }),
    .trig3_i({\u_fifo_top/u_fifo/wr_addr[7] ,\u_fifo_top/u_fifo/wr_addr[6] ,\u_fifo_top/u_fifo/wr_addr[5] ,\u_fifo_top/u_fifo/wr_addr[4] ,\u_fifo_top/u_fifo/wr_addr[3] ,\u_fifo_top/u_fifo/wr_addr[2] ,\u_fifo_top/u_fifo/wr_addr[1] ,\u_fifo_top/u_fifo/wr_addr[0] }),
    .trig4_i({\u_fifo_top/u_fifo/rd_addr[7] ,\u_fifo_top/u_fifo/rd_addr[6] ,\u_fifo_top/u_fifo/rd_addr[5] ,\u_fifo_top/u_fifo/rd_addr[4] ,\u_fifo_top/u_fifo/rd_addr[3] ,\u_fifo_top/u_fifo/rd_addr[2] ,\u_fifo_top/u_fifo/rd_addr[1] ,\u_fifo_top/u_fifo/rd_addr[0] }),
    .data_i({\u_fifo_top/u_fifo/wr_data[7] ,\u_fifo_top/u_fifo/wr_data[6] ,\u_fifo_top/u_fifo/wr_data[5] ,\u_fifo_top/u_fifo/wr_data[4] ,\u_fifo_top/u_fifo/wr_data[3] ,\u_fifo_top/u_fifo/wr_data[2] ,\u_fifo_top/u_fifo/wr_data[1] ,\u_fifo_top/u_fifo/wr_data[0] ,\u_fifo_top/u_fifo/rd_data[7] ,\u_fifo_top/u_fifo/rd_data[6] ,\u_fifo_top/u_fifo/rd_data[5] ,\u_fifo_top/u_fifo/rd_data[4] ,\u_fifo_top/u_fifo/rd_data[3] ,\u_fifo_top/u_fifo/rd_data[2] ,\u_fifo_top/u_fifo/rd_data[1] ,\u_fifo_top/u_fifo/rd_data[0] ,\u_fifo_top/u_fifo/wr_addr[7] ,\u_fifo_top/u_fifo/wr_addr[6] ,\u_fifo_top/u_fifo/wr_addr[5] ,\u_fifo_top/u_fifo/wr_addr[4] ,\u_fifo_top/u_fifo/wr_addr[3] ,\u_fifo_top/u_fifo/wr_addr[2] ,\u_fifo_top/u_fifo/wr_addr[1] ,\u_fifo_top/u_fifo/wr_addr[0] ,\u_fifo_top/u_fifo/rd_addr[7] ,\u_fifo_top/u_fifo/rd_addr[6] ,\u_fifo_top/u_fifo/rd_addr[5] ,\u_fifo_top/u_fifo/rd_addr[4] ,\u_fifo_top/u_fifo/rd_addr[3] ,\u_fifo_top/u_fifo/rd_addr[2] ,\u_fifo_top/u_fifo/rd_addr[1] ,\u_fifo_top/u_fifo/rd_addr[0] ,\u_fifo_top/frame_head_state[1] ,\u_fifo_top/frame_head_state[0] ,\u_fifo_top/u_fifo/phase ,\u_fifo_top/u_fifo/wr_en ,\u_fifo_top/u_uart_rx/rx_done ,\u_fifo_top/head_valid ,phase,tx_set}),
    .clk_i(sys_clk)
);

endmodule
