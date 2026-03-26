module gw_gao(
    \u_pms9103_data/Standard_PM1_0[15] ,
    \u_pms9103_data/Standard_PM1_0[14] ,
    \u_pms9103_data/Standard_PM1_0[13] ,
    \u_pms9103_data/Standard_PM1_0[12] ,
    \u_pms9103_data/Standard_PM1_0[11] ,
    \u_pms9103_data/Standard_PM1_0[10] ,
    \u_pms9103_data/Standard_PM1_0[9] ,
    \u_pms9103_data/Standard_PM1_0[8] ,
    \u_pms9103_data/Standard_PM1_0[7] ,
    \u_pms9103_data/Standard_PM1_0[6] ,
    \u_pms9103_data/Standard_PM1_0[5] ,
    \u_pms9103_data/Standard_PM1_0[4] ,
    \u_pms9103_data/Standard_PM1_0[3] ,
    \u_pms9103_data/Standard_PM1_0[2] ,
    \u_pms9103_data/Standard_PM1_0[1] ,
    \u_pms9103_data/Standard_PM1_0[0] ,
    \u_pms9103_data/Standard_PM2_5[15] ,
    \u_pms9103_data/Standard_PM2_5[14] ,
    \u_pms9103_data/Standard_PM2_5[13] ,
    \u_pms9103_data/Standard_PM2_5[12] ,
    \u_pms9103_data/Standard_PM2_5[11] ,
    \u_pms9103_data/Standard_PM2_5[10] ,
    \u_pms9103_data/Standard_PM2_5[9] ,
    \u_pms9103_data/Standard_PM2_5[8] ,
    \u_pms9103_data/Standard_PM2_5[7] ,
    \u_pms9103_data/Standard_PM2_5[6] ,
    \u_pms9103_data/Standard_PM2_5[5] ,
    \u_pms9103_data/Standard_PM2_5[4] ,
    \u_pms9103_data/Standard_PM2_5[3] ,
    \u_pms9103_data/Standard_PM2_5[2] ,
    \u_pms9103_data/Standard_PM2_5[1] ,
    \u_pms9103_data/Standard_PM2_5[0] ,
    \u_pms9103_data/Standard_PM10[15] ,
    \u_pms9103_data/Standard_PM10[14] ,
    \u_pms9103_data/Standard_PM10[13] ,
    \u_pms9103_data/Standard_PM10[12] ,
    \u_pms9103_data/Standard_PM10[11] ,
    \u_pms9103_data/Standard_PM10[10] ,
    \u_pms9103_data/Standard_PM10[9] ,
    \u_pms9103_data/Standard_PM10[8] ,
    \u_pms9103_data/Standard_PM10[7] ,
    \u_pms9103_data/Standard_PM10[6] ,
    \u_pms9103_data/Standard_PM10[5] ,
    \u_pms9103_data/Standard_PM10[4] ,
    \u_pms9103_data/Standard_PM10[3] ,
    \u_pms9103_data/Standard_PM10[2] ,
    \u_pms9103_data/Standard_PM10[1] ,
    \u_pms9103_data/Standard_PM10[0] ,
    \u_pms9103_data/Ambient_PM1_0[15] ,
    \u_pms9103_data/Ambient_PM1_0[14] ,
    \u_pms9103_data/Ambient_PM1_0[13] ,
    \u_pms9103_data/Ambient_PM1_0[12] ,
    \u_pms9103_data/Ambient_PM1_0[11] ,
    \u_pms9103_data/Ambient_PM1_0[10] ,
    \u_pms9103_data/Ambient_PM1_0[9] ,
    \u_pms9103_data/Ambient_PM1_0[8] ,
    \u_pms9103_data/Ambient_PM1_0[7] ,
    \u_pms9103_data/Ambient_PM1_0[6] ,
    \u_pms9103_data/Ambient_PM1_0[5] ,
    \u_pms9103_data/Ambient_PM1_0[4] ,
    \u_pms9103_data/Ambient_PM1_0[3] ,
    \u_pms9103_data/Ambient_PM1_0[2] ,
    \u_pms9103_data/Ambient_PM1_0[1] ,
    \u_pms9103_data/Ambient_PM1_0[0] ,
    \u_pms9103_data/Ambient_PM2_5[15] ,
    \u_pms9103_data/Ambient_PM2_5[14] ,
    \u_pms9103_data/Ambient_PM2_5[13] ,
    \u_pms9103_data/Ambient_PM2_5[12] ,
    \u_pms9103_data/Ambient_PM2_5[11] ,
    \u_pms9103_data/Ambient_PM2_5[10] ,
    \u_pms9103_data/Ambient_PM2_5[9] ,
    \u_pms9103_data/Ambient_PM2_5[8] ,
    \u_pms9103_data/Ambient_PM2_5[7] ,
    \u_pms9103_data/Ambient_PM2_5[6] ,
    \u_pms9103_data/Ambient_PM2_5[5] ,
    \u_pms9103_data/Ambient_PM2_5[4] ,
    \u_pms9103_data/Ambient_PM2_5[3] ,
    \u_pms9103_data/Ambient_PM2_5[2] ,
    \u_pms9103_data/Ambient_PM2_5[1] ,
    \u_pms9103_data/Ambient_PM2_5[0] ,
    \u_pms9103_data/Ambient_PM10[15] ,
    \u_pms9103_data/Ambient_PM10[14] ,
    \u_pms9103_data/Ambient_PM10[13] ,
    \u_pms9103_data/Ambient_PM10[12] ,
    \u_pms9103_data/Ambient_PM10[11] ,
    \u_pms9103_data/Ambient_PM10[10] ,
    \u_pms9103_data/Ambient_PM10[9] ,
    \u_pms9103_data/Ambient_PM10[8] ,
    \u_pms9103_data/Ambient_PM10[7] ,
    \u_pms9103_data/Ambient_PM10[6] ,
    \u_pms9103_data/Ambient_PM10[5] ,
    \u_pms9103_data/Ambient_PM10[4] ,
    \u_pms9103_data/Ambient_PM10[3] ,
    \u_pms9103_data/Ambient_PM10[2] ,
    \u_pms9103_data/Ambient_PM10[1] ,
    \u_pms9103_data/Ambient_PM10[0] ,
    \u_pms9103_data/PM0_3[15] ,
    \u_pms9103_data/PM0_3[14] ,
    \u_pms9103_data/PM0_3[13] ,
    \u_pms9103_data/PM0_3[12] ,
    \u_pms9103_data/PM0_3[11] ,
    \u_pms9103_data/PM0_3[10] ,
    \u_pms9103_data/PM0_3[9] ,
    \u_pms9103_data/PM0_3[8] ,
    \u_pms9103_data/PM0_3[7] ,
    \u_pms9103_data/PM0_3[6] ,
    \u_pms9103_data/PM0_3[5] ,
    \u_pms9103_data/PM0_3[4] ,
    \u_pms9103_data/PM0_3[3] ,
    \u_pms9103_data/PM0_3[2] ,
    \u_pms9103_data/PM0_3[1] ,
    \u_pms9103_data/PM0_3[0] ,
    \u_pms9103_data/PM0_5[15] ,
    \u_pms9103_data/PM0_5[14] ,
    \u_pms9103_data/PM0_5[13] ,
    \u_pms9103_data/PM0_5[12] ,
    \u_pms9103_data/PM0_5[11] ,
    \u_pms9103_data/PM0_5[10] ,
    \u_pms9103_data/PM0_5[9] ,
    \u_pms9103_data/PM0_5[8] ,
    \u_pms9103_data/PM0_5[7] ,
    \u_pms9103_data/PM0_5[6] ,
    \u_pms9103_data/PM0_5[5] ,
    \u_pms9103_data/PM0_5[4] ,
    \u_pms9103_data/PM0_5[3] ,
    \u_pms9103_data/PM0_5[2] ,
    \u_pms9103_data/PM0_5[1] ,
    \u_pms9103_data/PM0_5[0] ,
    \u_pms9103_data/PM1_0[15] ,
    \u_pms9103_data/PM1_0[14] ,
    \u_pms9103_data/PM1_0[13] ,
    \u_pms9103_data/PM1_0[12] ,
    \u_pms9103_data/PM1_0[11] ,
    \u_pms9103_data/PM1_0[10] ,
    \u_pms9103_data/PM1_0[9] ,
    \u_pms9103_data/PM1_0[8] ,
    \u_pms9103_data/PM1_0[7] ,
    \u_pms9103_data/PM1_0[6] ,
    \u_pms9103_data/PM1_0[5] ,
    \u_pms9103_data/PM1_0[4] ,
    \u_pms9103_data/PM1_0[3] ,
    \u_pms9103_data/PM1_0[2] ,
    \u_pms9103_data/PM1_0[1] ,
    \u_pms9103_data/PM1_0[0] ,
    \u_pms9103_data/data_buf[143] ,
    \u_pms9103_data/data_buf[142] ,
    \u_pms9103_data/data_buf[141] ,
    \u_pms9103_data/data_buf[140] ,
    \u_pms9103_data/data_buf[139] ,
    \u_pms9103_data/data_buf[138] ,
    \u_pms9103_data/data_buf[137] ,
    \u_pms9103_data/data_buf[136] ,
    \u_pms9103_data/data_buf[135] ,
    \u_pms9103_data/data_buf[134] ,
    \u_pms9103_data/data_buf[133] ,
    \u_pms9103_data/data_buf[132] ,
    \u_pms9103_data/data_buf[131] ,
    \u_pms9103_data/data_buf[130] ,
    \u_pms9103_data/data_buf[129] ,
    \u_pms9103_data/data_buf[128] ,
    \u_pms9103_data/data_buf[127] ,
    \u_pms9103_data/data_buf[126] ,
    \u_pms9103_data/data_buf[125] ,
    \u_pms9103_data/data_buf[124] ,
    \u_pms9103_data/data_buf[123] ,
    \u_pms9103_data/data_buf[122] ,
    \u_pms9103_data/data_buf[121] ,
    \u_pms9103_data/data_buf[120] ,
    \u_pms9103_data/data_buf[119] ,
    \u_pms9103_data/data_buf[118] ,
    \u_pms9103_data/data_buf[117] ,
    \u_pms9103_data/data_buf[116] ,
    \u_pms9103_data/data_buf[115] ,
    \u_pms9103_data/data_buf[114] ,
    \u_pms9103_data/data_buf[113] ,
    \u_pms9103_data/data_buf[112] ,
    \u_pms9103_data/data_buf[111] ,
    \u_pms9103_data/data_buf[110] ,
    \u_pms9103_data/data_buf[109] ,
    \u_pms9103_data/data_buf[108] ,
    \u_pms9103_data/data_buf[107] ,
    \u_pms9103_data/data_buf[106] ,
    \u_pms9103_data/data_buf[105] ,
    \u_pms9103_data/data_buf[104] ,
    \u_pms9103_data/data_buf[103] ,
    \u_pms9103_data/data_buf[102] ,
    \u_pms9103_data/data_buf[101] ,
    \u_pms9103_data/data_buf[100] ,
    \u_pms9103_data/data_buf[99] ,
    \u_pms9103_data/data_buf[98] ,
    \u_pms9103_data/data_buf[97] ,
    \u_pms9103_data/data_buf[96] ,
    \u_pms9103_data/data_buf[95] ,
    \u_pms9103_data/data_buf[94] ,
    \u_pms9103_data/data_buf[93] ,
    \u_pms9103_data/data_buf[92] ,
    \u_pms9103_data/data_buf[91] ,
    \u_pms9103_data/data_buf[90] ,
    \u_pms9103_data/data_buf[89] ,
    \u_pms9103_data/data_buf[88] ,
    \u_pms9103_data/data_buf[87] ,
    \u_pms9103_data/data_buf[86] ,
    \u_pms9103_data/data_buf[85] ,
    \u_pms9103_data/data_buf[84] ,
    \u_pms9103_data/data_buf[83] ,
    \u_pms9103_data/data_buf[82] ,
    \u_pms9103_data/data_buf[81] ,
    \u_pms9103_data/data_buf[80] ,
    \u_pms9103_data/data_buf[79] ,
    \u_pms9103_data/data_buf[78] ,
    \u_pms9103_data/data_buf[77] ,
    \u_pms9103_data/data_buf[76] ,
    \u_pms9103_data/data_buf[75] ,
    \u_pms9103_data/data_buf[74] ,
    \u_pms9103_data/data_buf[73] ,
    \u_pms9103_data/data_buf[72] ,
    \u_pms9103_data/data_buf[71] ,
    \u_pms9103_data/data_buf[70] ,
    \u_pms9103_data/data_buf[69] ,
    \u_pms9103_data/data_buf[68] ,
    \u_pms9103_data/data_buf[67] ,
    \u_pms9103_data/data_buf[66] ,
    \u_pms9103_data/data_buf[65] ,
    \u_pms9103_data/data_buf[64] ,
    \u_pms9103_data/data_buf[63] ,
    \u_pms9103_data/data_buf[62] ,
    \u_pms9103_data/data_buf[61] ,
    \u_pms9103_data/data_buf[60] ,
    \u_pms9103_data/data_buf[59] ,
    \u_pms9103_data/data_buf[58] ,
    \u_pms9103_data/data_buf[57] ,
    \u_pms9103_data/data_buf[56] ,
    \u_pms9103_data/data_buf[55] ,
    \u_pms9103_data/data_buf[54] ,
    \u_pms9103_data/data_buf[53] ,
    \u_pms9103_data/data_buf[52] ,
    \u_pms9103_data/data_buf[51] ,
    \u_pms9103_data/data_buf[50] ,
    \u_pms9103_data/data_buf[49] ,
    \u_pms9103_data/data_buf[48] ,
    \u_pms9103_data/data_buf[47] ,
    \u_pms9103_data/data_buf[46] ,
    \u_pms9103_data/data_buf[45] ,
    \u_pms9103_data/data_buf[44] ,
    \u_pms9103_data/data_buf[43] ,
    \u_pms9103_data/data_buf[42] ,
    \u_pms9103_data/data_buf[41] ,
    \u_pms9103_data/data_buf[40] ,
    \u_pms9103_data/data_buf[39] ,
    \u_pms9103_data/data_buf[38] ,
    \u_pms9103_data/data_buf[37] ,
    \u_pms9103_data/data_buf[36] ,
    \u_pms9103_data/data_buf[35] ,
    \u_pms9103_data/data_buf[34] ,
    \u_pms9103_data/data_buf[33] ,
    \u_pms9103_data/data_buf[32] ,
    \u_pms9103_data/data_buf[31] ,
    \u_pms9103_data/data_buf[30] ,
    \u_pms9103_data/data_buf[29] ,
    \u_pms9103_data/data_buf[28] ,
    \u_pms9103_data/data_buf[27] ,
    \u_pms9103_data/data_buf[26] ,
    \u_pms9103_data/data_buf[25] ,
    \u_pms9103_data/data_buf[24] ,
    \u_pms9103_data/data_buf[23] ,
    \u_pms9103_data/data_buf[22] ,
    \u_pms9103_data/data_buf[21] ,
    \u_pms9103_data/data_buf[20] ,
    \u_pms9103_data/data_buf[19] ,
    \u_pms9103_data/data_buf[18] ,
    \u_pms9103_data/data_buf[17] ,
    \u_pms9103_data/data_buf[16] ,
    \u_pms9103_data/data_buf[15] ,
    \u_pms9103_data/data_buf[14] ,
    \u_pms9103_data/data_buf[13] ,
    \u_pms9103_data/data_buf[12] ,
    \u_pms9103_data/data_buf[11] ,
    \u_pms9103_data/data_buf[10] ,
    \u_pms9103_data/data_buf[9] ,
    \u_pms9103_data/data_buf[8] ,
    \u_pms9103_data/data_buf[7] ,
    \u_pms9103_data/data_buf[6] ,
    \u_pms9103_data/data_buf[5] ,
    \u_pms9103_data/data_buf[4] ,
    \u_pms9103_data/data_buf[3] ,
    \u_pms9103_data/data_buf[2] ,
    \u_pms9103_data/data_buf[1] ,
    \u_pms9103_data/data_buf[0] ,
    data_ready,
    sys_clk,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input \u_pms9103_data/Standard_PM1_0[15] ;
input \u_pms9103_data/Standard_PM1_0[14] ;
input \u_pms9103_data/Standard_PM1_0[13] ;
input \u_pms9103_data/Standard_PM1_0[12] ;
input \u_pms9103_data/Standard_PM1_0[11] ;
input \u_pms9103_data/Standard_PM1_0[10] ;
input \u_pms9103_data/Standard_PM1_0[9] ;
input \u_pms9103_data/Standard_PM1_0[8] ;
input \u_pms9103_data/Standard_PM1_0[7] ;
input \u_pms9103_data/Standard_PM1_0[6] ;
input \u_pms9103_data/Standard_PM1_0[5] ;
input \u_pms9103_data/Standard_PM1_0[4] ;
input \u_pms9103_data/Standard_PM1_0[3] ;
input \u_pms9103_data/Standard_PM1_0[2] ;
input \u_pms9103_data/Standard_PM1_0[1] ;
input \u_pms9103_data/Standard_PM1_0[0] ;
input \u_pms9103_data/Standard_PM2_5[15] ;
input \u_pms9103_data/Standard_PM2_5[14] ;
input \u_pms9103_data/Standard_PM2_5[13] ;
input \u_pms9103_data/Standard_PM2_5[12] ;
input \u_pms9103_data/Standard_PM2_5[11] ;
input \u_pms9103_data/Standard_PM2_5[10] ;
input \u_pms9103_data/Standard_PM2_5[9] ;
input \u_pms9103_data/Standard_PM2_5[8] ;
input \u_pms9103_data/Standard_PM2_5[7] ;
input \u_pms9103_data/Standard_PM2_5[6] ;
input \u_pms9103_data/Standard_PM2_5[5] ;
input \u_pms9103_data/Standard_PM2_5[4] ;
input \u_pms9103_data/Standard_PM2_5[3] ;
input \u_pms9103_data/Standard_PM2_5[2] ;
input \u_pms9103_data/Standard_PM2_5[1] ;
input \u_pms9103_data/Standard_PM2_5[0] ;
input \u_pms9103_data/Standard_PM10[15] ;
input \u_pms9103_data/Standard_PM10[14] ;
input \u_pms9103_data/Standard_PM10[13] ;
input \u_pms9103_data/Standard_PM10[12] ;
input \u_pms9103_data/Standard_PM10[11] ;
input \u_pms9103_data/Standard_PM10[10] ;
input \u_pms9103_data/Standard_PM10[9] ;
input \u_pms9103_data/Standard_PM10[8] ;
input \u_pms9103_data/Standard_PM10[7] ;
input \u_pms9103_data/Standard_PM10[6] ;
input \u_pms9103_data/Standard_PM10[5] ;
input \u_pms9103_data/Standard_PM10[4] ;
input \u_pms9103_data/Standard_PM10[3] ;
input \u_pms9103_data/Standard_PM10[2] ;
input \u_pms9103_data/Standard_PM10[1] ;
input \u_pms9103_data/Standard_PM10[0] ;
input \u_pms9103_data/Ambient_PM1_0[15] ;
input \u_pms9103_data/Ambient_PM1_0[14] ;
input \u_pms9103_data/Ambient_PM1_0[13] ;
input \u_pms9103_data/Ambient_PM1_0[12] ;
input \u_pms9103_data/Ambient_PM1_0[11] ;
input \u_pms9103_data/Ambient_PM1_0[10] ;
input \u_pms9103_data/Ambient_PM1_0[9] ;
input \u_pms9103_data/Ambient_PM1_0[8] ;
input \u_pms9103_data/Ambient_PM1_0[7] ;
input \u_pms9103_data/Ambient_PM1_0[6] ;
input \u_pms9103_data/Ambient_PM1_0[5] ;
input \u_pms9103_data/Ambient_PM1_0[4] ;
input \u_pms9103_data/Ambient_PM1_0[3] ;
input \u_pms9103_data/Ambient_PM1_0[2] ;
input \u_pms9103_data/Ambient_PM1_0[1] ;
input \u_pms9103_data/Ambient_PM1_0[0] ;
input \u_pms9103_data/Ambient_PM2_5[15] ;
input \u_pms9103_data/Ambient_PM2_5[14] ;
input \u_pms9103_data/Ambient_PM2_5[13] ;
input \u_pms9103_data/Ambient_PM2_5[12] ;
input \u_pms9103_data/Ambient_PM2_5[11] ;
input \u_pms9103_data/Ambient_PM2_5[10] ;
input \u_pms9103_data/Ambient_PM2_5[9] ;
input \u_pms9103_data/Ambient_PM2_5[8] ;
input \u_pms9103_data/Ambient_PM2_5[7] ;
input \u_pms9103_data/Ambient_PM2_5[6] ;
input \u_pms9103_data/Ambient_PM2_5[5] ;
input \u_pms9103_data/Ambient_PM2_5[4] ;
input \u_pms9103_data/Ambient_PM2_5[3] ;
input \u_pms9103_data/Ambient_PM2_5[2] ;
input \u_pms9103_data/Ambient_PM2_5[1] ;
input \u_pms9103_data/Ambient_PM2_5[0] ;
input \u_pms9103_data/Ambient_PM10[15] ;
input \u_pms9103_data/Ambient_PM10[14] ;
input \u_pms9103_data/Ambient_PM10[13] ;
input \u_pms9103_data/Ambient_PM10[12] ;
input \u_pms9103_data/Ambient_PM10[11] ;
input \u_pms9103_data/Ambient_PM10[10] ;
input \u_pms9103_data/Ambient_PM10[9] ;
input \u_pms9103_data/Ambient_PM10[8] ;
input \u_pms9103_data/Ambient_PM10[7] ;
input \u_pms9103_data/Ambient_PM10[6] ;
input \u_pms9103_data/Ambient_PM10[5] ;
input \u_pms9103_data/Ambient_PM10[4] ;
input \u_pms9103_data/Ambient_PM10[3] ;
input \u_pms9103_data/Ambient_PM10[2] ;
input \u_pms9103_data/Ambient_PM10[1] ;
input \u_pms9103_data/Ambient_PM10[0] ;
input \u_pms9103_data/PM0_3[15] ;
input \u_pms9103_data/PM0_3[14] ;
input \u_pms9103_data/PM0_3[13] ;
input \u_pms9103_data/PM0_3[12] ;
input \u_pms9103_data/PM0_3[11] ;
input \u_pms9103_data/PM0_3[10] ;
input \u_pms9103_data/PM0_3[9] ;
input \u_pms9103_data/PM0_3[8] ;
input \u_pms9103_data/PM0_3[7] ;
input \u_pms9103_data/PM0_3[6] ;
input \u_pms9103_data/PM0_3[5] ;
input \u_pms9103_data/PM0_3[4] ;
input \u_pms9103_data/PM0_3[3] ;
input \u_pms9103_data/PM0_3[2] ;
input \u_pms9103_data/PM0_3[1] ;
input \u_pms9103_data/PM0_3[0] ;
input \u_pms9103_data/PM0_5[15] ;
input \u_pms9103_data/PM0_5[14] ;
input \u_pms9103_data/PM0_5[13] ;
input \u_pms9103_data/PM0_5[12] ;
input \u_pms9103_data/PM0_5[11] ;
input \u_pms9103_data/PM0_5[10] ;
input \u_pms9103_data/PM0_5[9] ;
input \u_pms9103_data/PM0_5[8] ;
input \u_pms9103_data/PM0_5[7] ;
input \u_pms9103_data/PM0_5[6] ;
input \u_pms9103_data/PM0_5[5] ;
input \u_pms9103_data/PM0_5[4] ;
input \u_pms9103_data/PM0_5[3] ;
input \u_pms9103_data/PM0_5[2] ;
input \u_pms9103_data/PM0_5[1] ;
input \u_pms9103_data/PM0_5[0] ;
input \u_pms9103_data/PM1_0[15] ;
input \u_pms9103_data/PM1_0[14] ;
input \u_pms9103_data/PM1_0[13] ;
input \u_pms9103_data/PM1_0[12] ;
input \u_pms9103_data/PM1_0[11] ;
input \u_pms9103_data/PM1_0[10] ;
input \u_pms9103_data/PM1_0[9] ;
input \u_pms9103_data/PM1_0[8] ;
input \u_pms9103_data/PM1_0[7] ;
input \u_pms9103_data/PM1_0[6] ;
input \u_pms9103_data/PM1_0[5] ;
input \u_pms9103_data/PM1_0[4] ;
input \u_pms9103_data/PM1_0[3] ;
input \u_pms9103_data/PM1_0[2] ;
input \u_pms9103_data/PM1_0[1] ;
input \u_pms9103_data/PM1_0[0] ;
input \u_pms9103_data/data_buf[143] ;
input \u_pms9103_data/data_buf[142] ;
input \u_pms9103_data/data_buf[141] ;
input \u_pms9103_data/data_buf[140] ;
input \u_pms9103_data/data_buf[139] ;
input \u_pms9103_data/data_buf[138] ;
input \u_pms9103_data/data_buf[137] ;
input \u_pms9103_data/data_buf[136] ;
input \u_pms9103_data/data_buf[135] ;
input \u_pms9103_data/data_buf[134] ;
input \u_pms9103_data/data_buf[133] ;
input \u_pms9103_data/data_buf[132] ;
input \u_pms9103_data/data_buf[131] ;
input \u_pms9103_data/data_buf[130] ;
input \u_pms9103_data/data_buf[129] ;
input \u_pms9103_data/data_buf[128] ;
input \u_pms9103_data/data_buf[127] ;
input \u_pms9103_data/data_buf[126] ;
input \u_pms9103_data/data_buf[125] ;
input \u_pms9103_data/data_buf[124] ;
input \u_pms9103_data/data_buf[123] ;
input \u_pms9103_data/data_buf[122] ;
input \u_pms9103_data/data_buf[121] ;
input \u_pms9103_data/data_buf[120] ;
input \u_pms9103_data/data_buf[119] ;
input \u_pms9103_data/data_buf[118] ;
input \u_pms9103_data/data_buf[117] ;
input \u_pms9103_data/data_buf[116] ;
input \u_pms9103_data/data_buf[115] ;
input \u_pms9103_data/data_buf[114] ;
input \u_pms9103_data/data_buf[113] ;
input \u_pms9103_data/data_buf[112] ;
input \u_pms9103_data/data_buf[111] ;
input \u_pms9103_data/data_buf[110] ;
input \u_pms9103_data/data_buf[109] ;
input \u_pms9103_data/data_buf[108] ;
input \u_pms9103_data/data_buf[107] ;
input \u_pms9103_data/data_buf[106] ;
input \u_pms9103_data/data_buf[105] ;
input \u_pms9103_data/data_buf[104] ;
input \u_pms9103_data/data_buf[103] ;
input \u_pms9103_data/data_buf[102] ;
input \u_pms9103_data/data_buf[101] ;
input \u_pms9103_data/data_buf[100] ;
input \u_pms9103_data/data_buf[99] ;
input \u_pms9103_data/data_buf[98] ;
input \u_pms9103_data/data_buf[97] ;
input \u_pms9103_data/data_buf[96] ;
input \u_pms9103_data/data_buf[95] ;
input \u_pms9103_data/data_buf[94] ;
input \u_pms9103_data/data_buf[93] ;
input \u_pms9103_data/data_buf[92] ;
input \u_pms9103_data/data_buf[91] ;
input \u_pms9103_data/data_buf[90] ;
input \u_pms9103_data/data_buf[89] ;
input \u_pms9103_data/data_buf[88] ;
input \u_pms9103_data/data_buf[87] ;
input \u_pms9103_data/data_buf[86] ;
input \u_pms9103_data/data_buf[85] ;
input \u_pms9103_data/data_buf[84] ;
input \u_pms9103_data/data_buf[83] ;
input \u_pms9103_data/data_buf[82] ;
input \u_pms9103_data/data_buf[81] ;
input \u_pms9103_data/data_buf[80] ;
input \u_pms9103_data/data_buf[79] ;
input \u_pms9103_data/data_buf[78] ;
input \u_pms9103_data/data_buf[77] ;
input \u_pms9103_data/data_buf[76] ;
input \u_pms9103_data/data_buf[75] ;
input \u_pms9103_data/data_buf[74] ;
input \u_pms9103_data/data_buf[73] ;
input \u_pms9103_data/data_buf[72] ;
input \u_pms9103_data/data_buf[71] ;
input \u_pms9103_data/data_buf[70] ;
input \u_pms9103_data/data_buf[69] ;
input \u_pms9103_data/data_buf[68] ;
input \u_pms9103_data/data_buf[67] ;
input \u_pms9103_data/data_buf[66] ;
input \u_pms9103_data/data_buf[65] ;
input \u_pms9103_data/data_buf[64] ;
input \u_pms9103_data/data_buf[63] ;
input \u_pms9103_data/data_buf[62] ;
input \u_pms9103_data/data_buf[61] ;
input \u_pms9103_data/data_buf[60] ;
input \u_pms9103_data/data_buf[59] ;
input \u_pms9103_data/data_buf[58] ;
input \u_pms9103_data/data_buf[57] ;
input \u_pms9103_data/data_buf[56] ;
input \u_pms9103_data/data_buf[55] ;
input \u_pms9103_data/data_buf[54] ;
input \u_pms9103_data/data_buf[53] ;
input \u_pms9103_data/data_buf[52] ;
input \u_pms9103_data/data_buf[51] ;
input \u_pms9103_data/data_buf[50] ;
input \u_pms9103_data/data_buf[49] ;
input \u_pms9103_data/data_buf[48] ;
input \u_pms9103_data/data_buf[47] ;
input \u_pms9103_data/data_buf[46] ;
input \u_pms9103_data/data_buf[45] ;
input \u_pms9103_data/data_buf[44] ;
input \u_pms9103_data/data_buf[43] ;
input \u_pms9103_data/data_buf[42] ;
input \u_pms9103_data/data_buf[41] ;
input \u_pms9103_data/data_buf[40] ;
input \u_pms9103_data/data_buf[39] ;
input \u_pms9103_data/data_buf[38] ;
input \u_pms9103_data/data_buf[37] ;
input \u_pms9103_data/data_buf[36] ;
input \u_pms9103_data/data_buf[35] ;
input \u_pms9103_data/data_buf[34] ;
input \u_pms9103_data/data_buf[33] ;
input \u_pms9103_data/data_buf[32] ;
input \u_pms9103_data/data_buf[31] ;
input \u_pms9103_data/data_buf[30] ;
input \u_pms9103_data/data_buf[29] ;
input \u_pms9103_data/data_buf[28] ;
input \u_pms9103_data/data_buf[27] ;
input \u_pms9103_data/data_buf[26] ;
input \u_pms9103_data/data_buf[25] ;
input \u_pms9103_data/data_buf[24] ;
input \u_pms9103_data/data_buf[23] ;
input \u_pms9103_data/data_buf[22] ;
input \u_pms9103_data/data_buf[21] ;
input \u_pms9103_data/data_buf[20] ;
input \u_pms9103_data/data_buf[19] ;
input \u_pms9103_data/data_buf[18] ;
input \u_pms9103_data/data_buf[17] ;
input \u_pms9103_data/data_buf[16] ;
input \u_pms9103_data/data_buf[15] ;
input \u_pms9103_data/data_buf[14] ;
input \u_pms9103_data/data_buf[13] ;
input \u_pms9103_data/data_buf[12] ;
input \u_pms9103_data/data_buf[11] ;
input \u_pms9103_data/data_buf[10] ;
input \u_pms9103_data/data_buf[9] ;
input \u_pms9103_data/data_buf[8] ;
input \u_pms9103_data/data_buf[7] ;
input \u_pms9103_data/data_buf[6] ;
input \u_pms9103_data/data_buf[5] ;
input \u_pms9103_data/data_buf[4] ;
input \u_pms9103_data/data_buf[3] ;
input \u_pms9103_data/data_buf[2] ;
input \u_pms9103_data/data_buf[1] ;
input \u_pms9103_data/data_buf[0] ;
input data_ready;
input sys_clk;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire \u_pms9103_data/Standard_PM1_0[15] ;
wire \u_pms9103_data/Standard_PM1_0[14] ;
wire \u_pms9103_data/Standard_PM1_0[13] ;
wire \u_pms9103_data/Standard_PM1_0[12] ;
wire \u_pms9103_data/Standard_PM1_0[11] ;
wire \u_pms9103_data/Standard_PM1_0[10] ;
wire \u_pms9103_data/Standard_PM1_0[9] ;
wire \u_pms9103_data/Standard_PM1_0[8] ;
wire \u_pms9103_data/Standard_PM1_0[7] ;
wire \u_pms9103_data/Standard_PM1_0[6] ;
wire \u_pms9103_data/Standard_PM1_0[5] ;
wire \u_pms9103_data/Standard_PM1_0[4] ;
wire \u_pms9103_data/Standard_PM1_0[3] ;
wire \u_pms9103_data/Standard_PM1_0[2] ;
wire \u_pms9103_data/Standard_PM1_0[1] ;
wire \u_pms9103_data/Standard_PM1_0[0] ;
wire \u_pms9103_data/Standard_PM2_5[15] ;
wire \u_pms9103_data/Standard_PM2_5[14] ;
wire \u_pms9103_data/Standard_PM2_5[13] ;
wire \u_pms9103_data/Standard_PM2_5[12] ;
wire \u_pms9103_data/Standard_PM2_5[11] ;
wire \u_pms9103_data/Standard_PM2_5[10] ;
wire \u_pms9103_data/Standard_PM2_5[9] ;
wire \u_pms9103_data/Standard_PM2_5[8] ;
wire \u_pms9103_data/Standard_PM2_5[7] ;
wire \u_pms9103_data/Standard_PM2_5[6] ;
wire \u_pms9103_data/Standard_PM2_5[5] ;
wire \u_pms9103_data/Standard_PM2_5[4] ;
wire \u_pms9103_data/Standard_PM2_5[3] ;
wire \u_pms9103_data/Standard_PM2_5[2] ;
wire \u_pms9103_data/Standard_PM2_5[1] ;
wire \u_pms9103_data/Standard_PM2_5[0] ;
wire \u_pms9103_data/Standard_PM10[15] ;
wire \u_pms9103_data/Standard_PM10[14] ;
wire \u_pms9103_data/Standard_PM10[13] ;
wire \u_pms9103_data/Standard_PM10[12] ;
wire \u_pms9103_data/Standard_PM10[11] ;
wire \u_pms9103_data/Standard_PM10[10] ;
wire \u_pms9103_data/Standard_PM10[9] ;
wire \u_pms9103_data/Standard_PM10[8] ;
wire \u_pms9103_data/Standard_PM10[7] ;
wire \u_pms9103_data/Standard_PM10[6] ;
wire \u_pms9103_data/Standard_PM10[5] ;
wire \u_pms9103_data/Standard_PM10[4] ;
wire \u_pms9103_data/Standard_PM10[3] ;
wire \u_pms9103_data/Standard_PM10[2] ;
wire \u_pms9103_data/Standard_PM10[1] ;
wire \u_pms9103_data/Standard_PM10[0] ;
wire \u_pms9103_data/Ambient_PM1_0[15] ;
wire \u_pms9103_data/Ambient_PM1_0[14] ;
wire \u_pms9103_data/Ambient_PM1_0[13] ;
wire \u_pms9103_data/Ambient_PM1_0[12] ;
wire \u_pms9103_data/Ambient_PM1_0[11] ;
wire \u_pms9103_data/Ambient_PM1_0[10] ;
wire \u_pms9103_data/Ambient_PM1_0[9] ;
wire \u_pms9103_data/Ambient_PM1_0[8] ;
wire \u_pms9103_data/Ambient_PM1_0[7] ;
wire \u_pms9103_data/Ambient_PM1_0[6] ;
wire \u_pms9103_data/Ambient_PM1_0[5] ;
wire \u_pms9103_data/Ambient_PM1_0[4] ;
wire \u_pms9103_data/Ambient_PM1_0[3] ;
wire \u_pms9103_data/Ambient_PM1_0[2] ;
wire \u_pms9103_data/Ambient_PM1_0[1] ;
wire \u_pms9103_data/Ambient_PM1_0[0] ;
wire \u_pms9103_data/Ambient_PM2_5[15] ;
wire \u_pms9103_data/Ambient_PM2_5[14] ;
wire \u_pms9103_data/Ambient_PM2_5[13] ;
wire \u_pms9103_data/Ambient_PM2_5[12] ;
wire \u_pms9103_data/Ambient_PM2_5[11] ;
wire \u_pms9103_data/Ambient_PM2_5[10] ;
wire \u_pms9103_data/Ambient_PM2_5[9] ;
wire \u_pms9103_data/Ambient_PM2_5[8] ;
wire \u_pms9103_data/Ambient_PM2_5[7] ;
wire \u_pms9103_data/Ambient_PM2_5[6] ;
wire \u_pms9103_data/Ambient_PM2_5[5] ;
wire \u_pms9103_data/Ambient_PM2_5[4] ;
wire \u_pms9103_data/Ambient_PM2_5[3] ;
wire \u_pms9103_data/Ambient_PM2_5[2] ;
wire \u_pms9103_data/Ambient_PM2_5[1] ;
wire \u_pms9103_data/Ambient_PM2_5[0] ;
wire \u_pms9103_data/Ambient_PM10[15] ;
wire \u_pms9103_data/Ambient_PM10[14] ;
wire \u_pms9103_data/Ambient_PM10[13] ;
wire \u_pms9103_data/Ambient_PM10[12] ;
wire \u_pms9103_data/Ambient_PM10[11] ;
wire \u_pms9103_data/Ambient_PM10[10] ;
wire \u_pms9103_data/Ambient_PM10[9] ;
wire \u_pms9103_data/Ambient_PM10[8] ;
wire \u_pms9103_data/Ambient_PM10[7] ;
wire \u_pms9103_data/Ambient_PM10[6] ;
wire \u_pms9103_data/Ambient_PM10[5] ;
wire \u_pms9103_data/Ambient_PM10[4] ;
wire \u_pms9103_data/Ambient_PM10[3] ;
wire \u_pms9103_data/Ambient_PM10[2] ;
wire \u_pms9103_data/Ambient_PM10[1] ;
wire \u_pms9103_data/Ambient_PM10[0] ;
wire \u_pms9103_data/PM0_3[15] ;
wire \u_pms9103_data/PM0_3[14] ;
wire \u_pms9103_data/PM0_3[13] ;
wire \u_pms9103_data/PM0_3[12] ;
wire \u_pms9103_data/PM0_3[11] ;
wire \u_pms9103_data/PM0_3[10] ;
wire \u_pms9103_data/PM0_3[9] ;
wire \u_pms9103_data/PM0_3[8] ;
wire \u_pms9103_data/PM0_3[7] ;
wire \u_pms9103_data/PM0_3[6] ;
wire \u_pms9103_data/PM0_3[5] ;
wire \u_pms9103_data/PM0_3[4] ;
wire \u_pms9103_data/PM0_3[3] ;
wire \u_pms9103_data/PM0_3[2] ;
wire \u_pms9103_data/PM0_3[1] ;
wire \u_pms9103_data/PM0_3[0] ;
wire \u_pms9103_data/PM0_5[15] ;
wire \u_pms9103_data/PM0_5[14] ;
wire \u_pms9103_data/PM0_5[13] ;
wire \u_pms9103_data/PM0_5[12] ;
wire \u_pms9103_data/PM0_5[11] ;
wire \u_pms9103_data/PM0_5[10] ;
wire \u_pms9103_data/PM0_5[9] ;
wire \u_pms9103_data/PM0_5[8] ;
wire \u_pms9103_data/PM0_5[7] ;
wire \u_pms9103_data/PM0_5[6] ;
wire \u_pms9103_data/PM0_5[5] ;
wire \u_pms9103_data/PM0_5[4] ;
wire \u_pms9103_data/PM0_5[3] ;
wire \u_pms9103_data/PM0_5[2] ;
wire \u_pms9103_data/PM0_5[1] ;
wire \u_pms9103_data/PM0_5[0] ;
wire \u_pms9103_data/PM1_0[15] ;
wire \u_pms9103_data/PM1_0[14] ;
wire \u_pms9103_data/PM1_0[13] ;
wire \u_pms9103_data/PM1_0[12] ;
wire \u_pms9103_data/PM1_0[11] ;
wire \u_pms9103_data/PM1_0[10] ;
wire \u_pms9103_data/PM1_0[9] ;
wire \u_pms9103_data/PM1_0[8] ;
wire \u_pms9103_data/PM1_0[7] ;
wire \u_pms9103_data/PM1_0[6] ;
wire \u_pms9103_data/PM1_0[5] ;
wire \u_pms9103_data/PM1_0[4] ;
wire \u_pms9103_data/PM1_0[3] ;
wire \u_pms9103_data/PM1_0[2] ;
wire \u_pms9103_data/PM1_0[1] ;
wire \u_pms9103_data/PM1_0[0] ;
wire \u_pms9103_data/data_buf[143] ;
wire \u_pms9103_data/data_buf[142] ;
wire \u_pms9103_data/data_buf[141] ;
wire \u_pms9103_data/data_buf[140] ;
wire \u_pms9103_data/data_buf[139] ;
wire \u_pms9103_data/data_buf[138] ;
wire \u_pms9103_data/data_buf[137] ;
wire \u_pms9103_data/data_buf[136] ;
wire \u_pms9103_data/data_buf[135] ;
wire \u_pms9103_data/data_buf[134] ;
wire \u_pms9103_data/data_buf[133] ;
wire \u_pms9103_data/data_buf[132] ;
wire \u_pms9103_data/data_buf[131] ;
wire \u_pms9103_data/data_buf[130] ;
wire \u_pms9103_data/data_buf[129] ;
wire \u_pms9103_data/data_buf[128] ;
wire \u_pms9103_data/data_buf[127] ;
wire \u_pms9103_data/data_buf[126] ;
wire \u_pms9103_data/data_buf[125] ;
wire \u_pms9103_data/data_buf[124] ;
wire \u_pms9103_data/data_buf[123] ;
wire \u_pms9103_data/data_buf[122] ;
wire \u_pms9103_data/data_buf[121] ;
wire \u_pms9103_data/data_buf[120] ;
wire \u_pms9103_data/data_buf[119] ;
wire \u_pms9103_data/data_buf[118] ;
wire \u_pms9103_data/data_buf[117] ;
wire \u_pms9103_data/data_buf[116] ;
wire \u_pms9103_data/data_buf[115] ;
wire \u_pms9103_data/data_buf[114] ;
wire \u_pms9103_data/data_buf[113] ;
wire \u_pms9103_data/data_buf[112] ;
wire \u_pms9103_data/data_buf[111] ;
wire \u_pms9103_data/data_buf[110] ;
wire \u_pms9103_data/data_buf[109] ;
wire \u_pms9103_data/data_buf[108] ;
wire \u_pms9103_data/data_buf[107] ;
wire \u_pms9103_data/data_buf[106] ;
wire \u_pms9103_data/data_buf[105] ;
wire \u_pms9103_data/data_buf[104] ;
wire \u_pms9103_data/data_buf[103] ;
wire \u_pms9103_data/data_buf[102] ;
wire \u_pms9103_data/data_buf[101] ;
wire \u_pms9103_data/data_buf[100] ;
wire \u_pms9103_data/data_buf[99] ;
wire \u_pms9103_data/data_buf[98] ;
wire \u_pms9103_data/data_buf[97] ;
wire \u_pms9103_data/data_buf[96] ;
wire \u_pms9103_data/data_buf[95] ;
wire \u_pms9103_data/data_buf[94] ;
wire \u_pms9103_data/data_buf[93] ;
wire \u_pms9103_data/data_buf[92] ;
wire \u_pms9103_data/data_buf[91] ;
wire \u_pms9103_data/data_buf[90] ;
wire \u_pms9103_data/data_buf[89] ;
wire \u_pms9103_data/data_buf[88] ;
wire \u_pms9103_data/data_buf[87] ;
wire \u_pms9103_data/data_buf[86] ;
wire \u_pms9103_data/data_buf[85] ;
wire \u_pms9103_data/data_buf[84] ;
wire \u_pms9103_data/data_buf[83] ;
wire \u_pms9103_data/data_buf[82] ;
wire \u_pms9103_data/data_buf[81] ;
wire \u_pms9103_data/data_buf[80] ;
wire \u_pms9103_data/data_buf[79] ;
wire \u_pms9103_data/data_buf[78] ;
wire \u_pms9103_data/data_buf[77] ;
wire \u_pms9103_data/data_buf[76] ;
wire \u_pms9103_data/data_buf[75] ;
wire \u_pms9103_data/data_buf[74] ;
wire \u_pms9103_data/data_buf[73] ;
wire \u_pms9103_data/data_buf[72] ;
wire \u_pms9103_data/data_buf[71] ;
wire \u_pms9103_data/data_buf[70] ;
wire \u_pms9103_data/data_buf[69] ;
wire \u_pms9103_data/data_buf[68] ;
wire \u_pms9103_data/data_buf[67] ;
wire \u_pms9103_data/data_buf[66] ;
wire \u_pms9103_data/data_buf[65] ;
wire \u_pms9103_data/data_buf[64] ;
wire \u_pms9103_data/data_buf[63] ;
wire \u_pms9103_data/data_buf[62] ;
wire \u_pms9103_data/data_buf[61] ;
wire \u_pms9103_data/data_buf[60] ;
wire \u_pms9103_data/data_buf[59] ;
wire \u_pms9103_data/data_buf[58] ;
wire \u_pms9103_data/data_buf[57] ;
wire \u_pms9103_data/data_buf[56] ;
wire \u_pms9103_data/data_buf[55] ;
wire \u_pms9103_data/data_buf[54] ;
wire \u_pms9103_data/data_buf[53] ;
wire \u_pms9103_data/data_buf[52] ;
wire \u_pms9103_data/data_buf[51] ;
wire \u_pms9103_data/data_buf[50] ;
wire \u_pms9103_data/data_buf[49] ;
wire \u_pms9103_data/data_buf[48] ;
wire \u_pms9103_data/data_buf[47] ;
wire \u_pms9103_data/data_buf[46] ;
wire \u_pms9103_data/data_buf[45] ;
wire \u_pms9103_data/data_buf[44] ;
wire \u_pms9103_data/data_buf[43] ;
wire \u_pms9103_data/data_buf[42] ;
wire \u_pms9103_data/data_buf[41] ;
wire \u_pms9103_data/data_buf[40] ;
wire \u_pms9103_data/data_buf[39] ;
wire \u_pms9103_data/data_buf[38] ;
wire \u_pms9103_data/data_buf[37] ;
wire \u_pms9103_data/data_buf[36] ;
wire \u_pms9103_data/data_buf[35] ;
wire \u_pms9103_data/data_buf[34] ;
wire \u_pms9103_data/data_buf[33] ;
wire \u_pms9103_data/data_buf[32] ;
wire \u_pms9103_data/data_buf[31] ;
wire \u_pms9103_data/data_buf[30] ;
wire \u_pms9103_data/data_buf[29] ;
wire \u_pms9103_data/data_buf[28] ;
wire \u_pms9103_data/data_buf[27] ;
wire \u_pms9103_data/data_buf[26] ;
wire \u_pms9103_data/data_buf[25] ;
wire \u_pms9103_data/data_buf[24] ;
wire \u_pms9103_data/data_buf[23] ;
wire \u_pms9103_data/data_buf[22] ;
wire \u_pms9103_data/data_buf[21] ;
wire \u_pms9103_data/data_buf[20] ;
wire \u_pms9103_data/data_buf[19] ;
wire \u_pms9103_data/data_buf[18] ;
wire \u_pms9103_data/data_buf[17] ;
wire \u_pms9103_data/data_buf[16] ;
wire \u_pms9103_data/data_buf[15] ;
wire \u_pms9103_data/data_buf[14] ;
wire \u_pms9103_data/data_buf[13] ;
wire \u_pms9103_data/data_buf[12] ;
wire \u_pms9103_data/data_buf[11] ;
wire \u_pms9103_data/data_buf[10] ;
wire \u_pms9103_data/data_buf[9] ;
wire \u_pms9103_data/data_buf[8] ;
wire \u_pms9103_data/data_buf[7] ;
wire \u_pms9103_data/data_buf[6] ;
wire \u_pms9103_data/data_buf[5] ;
wire \u_pms9103_data/data_buf[4] ;
wire \u_pms9103_data/data_buf[3] ;
wire \u_pms9103_data/data_buf[2] ;
wire \u_pms9103_data/data_buf[1] ;
wire \u_pms9103_data/data_buf[0] ;
wire data_ready;
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
    .trig0_i(data_ready),
    .data_i({\u_pms9103_data/Standard_PM1_0[15] ,\u_pms9103_data/Standard_PM1_0[14] ,\u_pms9103_data/Standard_PM1_0[13] ,\u_pms9103_data/Standard_PM1_0[12] ,\u_pms9103_data/Standard_PM1_0[11] ,\u_pms9103_data/Standard_PM1_0[10] ,\u_pms9103_data/Standard_PM1_0[9] ,\u_pms9103_data/Standard_PM1_0[8] ,\u_pms9103_data/Standard_PM1_0[7] ,\u_pms9103_data/Standard_PM1_0[6] ,\u_pms9103_data/Standard_PM1_0[5] ,\u_pms9103_data/Standard_PM1_0[4] ,\u_pms9103_data/Standard_PM1_0[3] ,\u_pms9103_data/Standard_PM1_0[2] ,\u_pms9103_data/Standard_PM1_0[1] ,\u_pms9103_data/Standard_PM1_0[0] ,\u_pms9103_data/Standard_PM2_5[15] ,\u_pms9103_data/Standard_PM2_5[14] ,\u_pms9103_data/Standard_PM2_5[13] ,\u_pms9103_data/Standard_PM2_5[12] ,\u_pms9103_data/Standard_PM2_5[11] ,\u_pms9103_data/Standard_PM2_5[10] ,\u_pms9103_data/Standard_PM2_5[9] ,\u_pms9103_data/Standard_PM2_5[8] ,\u_pms9103_data/Standard_PM2_5[7] ,\u_pms9103_data/Standard_PM2_5[6] ,\u_pms9103_data/Standard_PM2_5[5] ,\u_pms9103_data/Standard_PM2_5[4] ,\u_pms9103_data/Standard_PM2_5[3] ,\u_pms9103_data/Standard_PM2_5[2] ,\u_pms9103_data/Standard_PM2_5[1] ,\u_pms9103_data/Standard_PM2_5[0] ,\u_pms9103_data/Standard_PM10[15] ,\u_pms9103_data/Standard_PM10[14] ,\u_pms9103_data/Standard_PM10[13] ,\u_pms9103_data/Standard_PM10[12] ,\u_pms9103_data/Standard_PM10[11] ,\u_pms9103_data/Standard_PM10[10] ,\u_pms9103_data/Standard_PM10[9] ,\u_pms9103_data/Standard_PM10[8] ,\u_pms9103_data/Standard_PM10[7] ,\u_pms9103_data/Standard_PM10[6] ,\u_pms9103_data/Standard_PM10[5] ,\u_pms9103_data/Standard_PM10[4] ,\u_pms9103_data/Standard_PM10[3] ,\u_pms9103_data/Standard_PM10[2] ,\u_pms9103_data/Standard_PM10[1] ,\u_pms9103_data/Standard_PM10[0] ,\u_pms9103_data/Ambient_PM1_0[15] ,\u_pms9103_data/Ambient_PM1_0[14] ,\u_pms9103_data/Ambient_PM1_0[13] ,\u_pms9103_data/Ambient_PM1_0[12] ,\u_pms9103_data/Ambient_PM1_0[11] ,\u_pms9103_data/Ambient_PM1_0[10] ,\u_pms9103_data/Ambient_PM1_0[9] ,\u_pms9103_data/Ambient_PM1_0[8] ,\u_pms9103_data/Ambient_PM1_0[7] ,\u_pms9103_data/Ambient_PM1_0[6] ,\u_pms9103_data/Ambient_PM1_0[5] ,\u_pms9103_data/Ambient_PM1_0[4] ,\u_pms9103_data/Ambient_PM1_0[3] ,\u_pms9103_data/Ambient_PM1_0[2] ,\u_pms9103_data/Ambient_PM1_0[1] ,\u_pms9103_data/Ambient_PM1_0[0] ,\u_pms9103_data/Ambient_PM2_5[15] ,\u_pms9103_data/Ambient_PM2_5[14] ,\u_pms9103_data/Ambient_PM2_5[13] ,\u_pms9103_data/Ambient_PM2_5[12] ,\u_pms9103_data/Ambient_PM2_5[11] ,\u_pms9103_data/Ambient_PM2_5[10] ,\u_pms9103_data/Ambient_PM2_5[9] ,\u_pms9103_data/Ambient_PM2_5[8] ,\u_pms9103_data/Ambient_PM2_5[7] ,\u_pms9103_data/Ambient_PM2_5[6] ,\u_pms9103_data/Ambient_PM2_5[5] ,\u_pms9103_data/Ambient_PM2_5[4] ,\u_pms9103_data/Ambient_PM2_5[3] ,\u_pms9103_data/Ambient_PM2_5[2] ,\u_pms9103_data/Ambient_PM2_5[1] ,\u_pms9103_data/Ambient_PM2_5[0] ,\u_pms9103_data/Ambient_PM10[15] ,\u_pms9103_data/Ambient_PM10[14] ,\u_pms9103_data/Ambient_PM10[13] ,\u_pms9103_data/Ambient_PM10[12] ,\u_pms9103_data/Ambient_PM10[11] ,\u_pms9103_data/Ambient_PM10[10] ,\u_pms9103_data/Ambient_PM10[9] ,\u_pms9103_data/Ambient_PM10[8] ,\u_pms9103_data/Ambient_PM10[7] ,\u_pms9103_data/Ambient_PM10[6] ,\u_pms9103_data/Ambient_PM10[5] ,\u_pms9103_data/Ambient_PM10[4] ,\u_pms9103_data/Ambient_PM10[3] ,\u_pms9103_data/Ambient_PM10[2] ,\u_pms9103_data/Ambient_PM10[1] ,\u_pms9103_data/Ambient_PM10[0] ,\u_pms9103_data/PM0_3[15] ,\u_pms9103_data/PM0_3[14] ,\u_pms9103_data/PM0_3[13] ,\u_pms9103_data/PM0_3[12] ,\u_pms9103_data/PM0_3[11] ,\u_pms9103_data/PM0_3[10] ,\u_pms9103_data/PM0_3[9] ,\u_pms9103_data/PM0_3[8] ,\u_pms9103_data/PM0_3[7] ,\u_pms9103_data/PM0_3[6] ,\u_pms9103_data/PM0_3[5] ,\u_pms9103_data/PM0_3[4] ,\u_pms9103_data/PM0_3[3] ,\u_pms9103_data/PM0_3[2] ,\u_pms9103_data/PM0_3[1] ,\u_pms9103_data/PM0_3[0] ,\u_pms9103_data/PM0_5[15] ,\u_pms9103_data/PM0_5[14] ,\u_pms9103_data/PM0_5[13] ,\u_pms9103_data/PM0_5[12] ,\u_pms9103_data/PM0_5[11] ,\u_pms9103_data/PM0_5[10] ,\u_pms9103_data/PM0_5[9] ,\u_pms9103_data/PM0_5[8] ,\u_pms9103_data/PM0_5[7] ,\u_pms9103_data/PM0_5[6] ,\u_pms9103_data/PM0_5[5] ,\u_pms9103_data/PM0_5[4] ,\u_pms9103_data/PM0_5[3] ,\u_pms9103_data/PM0_5[2] ,\u_pms9103_data/PM0_5[1] ,\u_pms9103_data/PM0_5[0] ,\u_pms9103_data/PM1_0[15] ,\u_pms9103_data/PM1_0[14] ,\u_pms9103_data/PM1_0[13] ,\u_pms9103_data/PM1_0[12] ,\u_pms9103_data/PM1_0[11] ,\u_pms9103_data/PM1_0[10] ,\u_pms9103_data/PM1_0[9] ,\u_pms9103_data/PM1_0[8] ,\u_pms9103_data/PM1_0[7] ,\u_pms9103_data/PM1_0[6] ,\u_pms9103_data/PM1_0[5] ,\u_pms9103_data/PM1_0[4] ,\u_pms9103_data/PM1_0[3] ,\u_pms9103_data/PM1_0[2] ,\u_pms9103_data/PM1_0[1] ,\u_pms9103_data/PM1_0[0] ,\u_pms9103_data/data_buf[143] ,\u_pms9103_data/data_buf[142] ,\u_pms9103_data/data_buf[141] ,\u_pms9103_data/data_buf[140] ,\u_pms9103_data/data_buf[139] ,\u_pms9103_data/data_buf[138] ,\u_pms9103_data/data_buf[137] ,\u_pms9103_data/data_buf[136] ,\u_pms9103_data/data_buf[135] ,\u_pms9103_data/data_buf[134] ,\u_pms9103_data/data_buf[133] ,\u_pms9103_data/data_buf[132] ,\u_pms9103_data/data_buf[131] ,\u_pms9103_data/data_buf[130] ,\u_pms9103_data/data_buf[129] ,\u_pms9103_data/data_buf[128] ,\u_pms9103_data/data_buf[127] ,\u_pms9103_data/data_buf[126] ,\u_pms9103_data/data_buf[125] ,\u_pms9103_data/data_buf[124] ,\u_pms9103_data/data_buf[123] ,\u_pms9103_data/data_buf[122] ,\u_pms9103_data/data_buf[121] ,\u_pms9103_data/data_buf[120] ,\u_pms9103_data/data_buf[119] ,\u_pms9103_data/data_buf[118] ,\u_pms9103_data/data_buf[117] ,\u_pms9103_data/data_buf[116] ,\u_pms9103_data/data_buf[115] ,\u_pms9103_data/data_buf[114] ,\u_pms9103_data/data_buf[113] ,\u_pms9103_data/data_buf[112] ,\u_pms9103_data/data_buf[111] ,\u_pms9103_data/data_buf[110] ,\u_pms9103_data/data_buf[109] ,\u_pms9103_data/data_buf[108] ,\u_pms9103_data/data_buf[107] ,\u_pms9103_data/data_buf[106] ,\u_pms9103_data/data_buf[105] ,\u_pms9103_data/data_buf[104] ,\u_pms9103_data/data_buf[103] ,\u_pms9103_data/data_buf[102] ,\u_pms9103_data/data_buf[101] ,\u_pms9103_data/data_buf[100] ,\u_pms9103_data/data_buf[99] ,\u_pms9103_data/data_buf[98] ,\u_pms9103_data/data_buf[97] ,\u_pms9103_data/data_buf[96] ,\u_pms9103_data/data_buf[95] ,\u_pms9103_data/data_buf[94] ,\u_pms9103_data/data_buf[93] ,\u_pms9103_data/data_buf[92] ,\u_pms9103_data/data_buf[91] ,\u_pms9103_data/data_buf[90] ,\u_pms9103_data/data_buf[89] ,\u_pms9103_data/data_buf[88] ,\u_pms9103_data/data_buf[87] ,\u_pms9103_data/data_buf[86] ,\u_pms9103_data/data_buf[85] ,\u_pms9103_data/data_buf[84] ,\u_pms9103_data/data_buf[83] ,\u_pms9103_data/data_buf[82] ,\u_pms9103_data/data_buf[81] ,\u_pms9103_data/data_buf[80] ,\u_pms9103_data/data_buf[79] ,\u_pms9103_data/data_buf[78] ,\u_pms9103_data/data_buf[77] ,\u_pms9103_data/data_buf[76] ,\u_pms9103_data/data_buf[75] ,\u_pms9103_data/data_buf[74] ,\u_pms9103_data/data_buf[73] ,\u_pms9103_data/data_buf[72] ,\u_pms9103_data/data_buf[71] ,\u_pms9103_data/data_buf[70] ,\u_pms9103_data/data_buf[69] ,\u_pms9103_data/data_buf[68] ,\u_pms9103_data/data_buf[67] ,\u_pms9103_data/data_buf[66] ,\u_pms9103_data/data_buf[65] ,\u_pms9103_data/data_buf[64] ,\u_pms9103_data/data_buf[63] ,\u_pms9103_data/data_buf[62] ,\u_pms9103_data/data_buf[61] ,\u_pms9103_data/data_buf[60] ,\u_pms9103_data/data_buf[59] ,\u_pms9103_data/data_buf[58] ,\u_pms9103_data/data_buf[57] ,\u_pms9103_data/data_buf[56] ,\u_pms9103_data/data_buf[55] ,\u_pms9103_data/data_buf[54] ,\u_pms9103_data/data_buf[53] ,\u_pms9103_data/data_buf[52] ,\u_pms9103_data/data_buf[51] ,\u_pms9103_data/data_buf[50] ,\u_pms9103_data/data_buf[49] ,\u_pms9103_data/data_buf[48] ,\u_pms9103_data/data_buf[47] ,\u_pms9103_data/data_buf[46] ,\u_pms9103_data/data_buf[45] ,\u_pms9103_data/data_buf[44] ,\u_pms9103_data/data_buf[43] ,\u_pms9103_data/data_buf[42] ,\u_pms9103_data/data_buf[41] ,\u_pms9103_data/data_buf[40] ,\u_pms9103_data/data_buf[39] ,\u_pms9103_data/data_buf[38] ,\u_pms9103_data/data_buf[37] ,\u_pms9103_data/data_buf[36] ,\u_pms9103_data/data_buf[35] ,\u_pms9103_data/data_buf[34] ,\u_pms9103_data/data_buf[33] ,\u_pms9103_data/data_buf[32] ,\u_pms9103_data/data_buf[31] ,\u_pms9103_data/data_buf[30] ,\u_pms9103_data/data_buf[29] ,\u_pms9103_data/data_buf[28] ,\u_pms9103_data/data_buf[27] ,\u_pms9103_data/data_buf[26] ,\u_pms9103_data/data_buf[25] ,\u_pms9103_data/data_buf[24] ,\u_pms9103_data/data_buf[23] ,\u_pms9103_data/data_buf[22] ,\u_pms9103_data/data_buf[21] ,\u_pms9103_data/data_buf[20] ,\u_pms9103_data/data_buf[19] ,\u_pms9103_data/data_buf[18] ,\u_pms9103_data/data_buf[17] ,\u_pms9103_data/data_buf[16] ,\u_pms9103_data/data_buf[15] ,\u_pms9103_data/data_buf[14] ,\u_pms9103_data/data_buf[13] ,\u_pms9103_data/data_buf[12] ,\u_pms9103_data/data_buf[11] ,\u_pms9103_data/data_buf[10] ,\u_pms9103_data/data_buf[9] ,\u_pms9103_data/data_buf[8] ,\u_pms9103_data/data_buf[7] ,\u_pms9103_data/data_buf[6] ,\u_pms9103_data/data_buf[5] ,\u_pms9103_data/data_buf[4] ,\u_pms9103_data/data_buf[3] ,\u_pms9103_data/data_buf[2] ,\u_pms9103_data/data_buf[1] ,\u_pms9103_data/data_buf[0] }),
    .clk_i(sys_clk)
);

endmodule
