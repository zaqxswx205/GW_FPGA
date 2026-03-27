module i2c_write_one_bit(
    input sys_clk,
    input sys_rst_n,

    output scl,
    output sda
);



i2c_write_addr u_i2c_write_addr(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .i2c_send_addr_set(1'b1),
    .scl(scl),
    .sda(sda)
);


endmodule