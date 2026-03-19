module fifo(
    input sys_clk,
    input sys_rst_n,

    input wr_en,
    input [7:0] wr_data,

    input rd_en,
    output [7:0] rd_data,
    output reg phase

);

parameter DEPTH = 8'd30;

reg [7:0] mem [DEPTH-1'b1:0];
reg [7:0] wr_addr;
reg [7:0] rd_addr;

assign rd_data = mem[rd_addr];

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        phase <= 1'b0;
        wr_addr <= 8'd0;
        rd_addr <= 8'd0;
    end
    else begin
        if (!phase) begin
            if (wr_en) begin
                mem[wr_addr] <= wr_data;
                if (wr_addr == DEPTH-1) begin
                    phase <= 1'b1;
                    wr_addr <= 8'd0;
                    rd_addr <= 8'd0;
                end
                else begin
                    wr_addr <= wr_addr + 1'b1;
                end
            end
            else begin
                wr_addr <= wr_addr;
            end
        end
        else begin
            if (rd_en) begin
                if (rd_addr == DEPTH-1) begin
                    phase <= 1'b0;
                    wr_addr <= 8'd0;
                    rd_addr <= 8'd0;
                end
                else begin
                    rd_addr <= rd_addr + 1'b1;
                end
            end
            else begin
                rd_addr <= rd_addr;
            end
        end
    end
end

endmodule