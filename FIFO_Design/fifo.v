`timescale 1ns/1ps

module fifo (
    input clk,
    input rst,
    input wr_en,
    input rd_en,
    input [3:0] data_in,
    output reg [3:0] data_out,
    output full,
    output empty
);

parameter DEPTH = 8;

reg [7:0] mem [0:DEPTH-1];
reg [2:0] wr_ptr;
reg [2:0] rd_ptr;
reg [3:0] count;

assign full  = (count == DEPTH);
assign empty = (count == 0);

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        wr_ptr <= 0;
        rd_ptr <= 0;
        count  <= 0;
        data_out <= 0;
    end
    else
    begin

        // Write Operation
        if(wr_en && !full)
        begin
            mem[wr_ptr] <= data_in;
            wr_ptr <= wr_ptr + 1;
            count <= count + 1;
        end

        // Read Operation
        if(rd_en && !empty)
        begin
            data_out <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
            count <= count - 1;
        end

    end
end

endmodule
