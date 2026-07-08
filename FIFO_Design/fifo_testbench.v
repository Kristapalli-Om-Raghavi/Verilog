`timescale 1ns/1ps

module fifo_tb;
reg clk;
reg rst;
reg wr_en;
reg rd_en;
reg [3:0] data_in;
wire [3:0] data_out;
wire full;
wire empty;

fifo dut(
    .clk(clk),
    .rst(rst),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .data_in(data_in),
    .data_out(data_out),
    .full(full),
    .empty(empty)
);

// Clock Generation
always #5 clk = ~clk;

// Write Task
task write_fifo;
input [3:0] data;
begin
    @(posedge clk);
    wr_en = 1;
    rd_en = 0;
    data_in = data;
    @(posedge clk);
    wr_en = 0;
    $display("WRITE : %d Full=%b Empty=%b",data,full,empty);
end
endtask
// Read Task
task read_fifo;
begin
    @(posedge clk);
    wr_en = 0;
    rd_en = 1;
    @(posedge clk);
    rd_en = 0;
    $display("READ  : %d Full=%b Empty=%b",data_out,full,empty);
end
endtask
initial
begin
    clk = 0;
    rst = 1;
    wr_en = 0;
    rd_en = 0;
    data_in = 0;
    #20;
    rst = 0;
// Write Data
    write_fifo(6);
    write_fifo(7);
    write_fifo(8);
    write_fifo(9);

// Read Data
    read_fifo();
    read_fifo();
// Write More
    write_fifo(10);
    write_fifo(15);
// Read Remaining
    read_fifo();
    read_fifo();
    read_fifo();
    read_fifo();
#20;
 $finish;

end

endmodule
