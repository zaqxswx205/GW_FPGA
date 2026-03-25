module fifo
#(
    parameter WIDTH  = 8,
    parameter DEPTH  = 32,
    parameter ADDR_W = 5
)
(
    input              sys_clk,
    input              sys_rst_n,

    input  [WIDTH-1:0] wr_data,
    input              wr_en,
    output             full,

    output [WIDTH-1:0] rd_data,
    input              rd_en,
    output             empty
);

// 1. 内存
reg [WIDTH-1:0] mem[DEPTH-1:0];

// 2. 读写指针（多 1 位用来判断绕圈）
reg [ADDR_W:0] wr_ptr;
reg [ADDR_W:0] rd_ptr;

// 3. 真正的写/读地址（去掉最高位）
wire [ADDR_W-1:0] wr_addr = wr_ptr[ADDR_W-1:0];
wire [ADDR_W-1:0] rd_addr = rd_ptr[ADDR_W-1:0];

// ============================
// 写逻辑
// ============================
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        wr_ptr <= 0;
    else if(wr_en && !full) begin
        mem[wr_addr] <= wr_data;
        wr_ptr      <= wr_ptr + 1'd1;
    end
end

// ============================
// 读逻辑
// ============================
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        rd_ptr <= 0;
    else if(rd_en && !empty)
        rd_ptr <= rd_ptr + 1'd1;
end

assign rd_data = mem[rd_addr];

// ============================
// 空满判断（环形FIFO核心！用异或）
// ============================
assign empty = ~|(wr_ptr ^ rd_ptr);
assign full  = (wr_ptr ^ rd_ptr) == {1'b1, {ADDR_W{1'b0}}};  // 仅最高位为1：绕圈

endmodule