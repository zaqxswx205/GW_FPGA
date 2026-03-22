module loop_fifo (
    input sys_clk,
    input sys_rst_n,

    input [7:0] wr_data,
    input wr_en,
    output full,

    output [7:0] rd_data,
    input rd_en,
    output empty
);

reg [7:0] mem[31:0];
reg [5:0] wr_ptr;
reg [5:0] rd_ptr;

wire [4:0] wr_addr = wr_ptr[4:0];
wire [4:0] rd_addr = rd_ptr[4:0];

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        wr_ptr <= 0;
    end
    else if (wr_en && !full) begin
        mem[wr_addr] <= wr_data;
        wr_ptr <= wr_ptr + 1'd1;
    end
    else begin
        wr_ptr <= wr_ptr;
    end
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        rd_ptr <= 0;
    end
    else if (rd_en && !empty) begin
        rd_ptr <= rd_ptr + 1'd1;
    end
    else begin
        rd_ptr <= rd_ptr;
    end
end

assign rd_data = mem[rd_addr];

assign empty = ~|(wr_ptr ^ rd_ptr);
assign full = (wr_ptr ^ rd_ptr) == {1'b1, {5{1'b0}}};


endmodule