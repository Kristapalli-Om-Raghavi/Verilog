`timescale 1ns / 1ps

module uart_tb;

reg clk;
reg rst;
reg tx_start;
reg [7:0] data_in;

wire tx;
wire tx_done;
wire [7:0] data_out;
wire rx_done;
// Test counters
integer total_tests;
integer passed_tests;

uart_top uut (
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .data_in(data_in),
    .tx(tx),
    .tx_done(tx_done),
    .data_out(data_out),
    .rx_done(rx_done)
);
always #10 clk = ~clk;

initial begin
    $monitor("TIME=%0t | rst=%b | tx_start=%b | data_in=%h | tx=%b | tx_done=%b | rx_done=%b | data_out=%h",
              $time, rst, tx_start, data_in, tx, tx_done, rx_done, data_out);
end
initial
begin
    clk = 0;
    rst = 1;
    tx_start = 0;
    data_in = 8'h00;

    total_tests = 0;
    passed_tests = 0;
    $display(" UART Simulation Started ");
    #100;
    rst = 0;
    // Test 1 : A5
    #100;
    total_tests = total_tests + 1;

    data_in = 8'hA5;
    tx_start = 1;
    #20;
    tx_start = 0;

    wait(rx_done);

    if(data_out == 8'hA5)
    begin
        passed_tests = passed_tests + 1;
        $display("TEST-1 PASS : Sent=%h Received=%h",8'hA5,data_out);
    end
    else
        $display("TEST-1 FAIL : Sent=%h Received=%h",8'hA5,data_out);

    #1000;
    // Test 2 : 3C
    total_tests = total_tests + 1;

    data_in = 8'h3C;
    tx_start = 1;
    #20;
    tx_start = 0;

    wait(rx_done);

    if(data_out == 8'h3C)
    begin
        passed_tests = passed_tests + 1;
        $display("TEST-2 PASS : Sent=%h Received=%h",8'h3C,data_out);
    end
    else
        $display("TEST-2 FAIL : Sent=%h Received=%h",8'h3C,data_out);

    #1000;
    $display("Simulation Finished");
    $display("Total Tests  = %0d", total_tests);
    $display("Passed Tests = %0d", passed_tests);
    $display("Failed Tests = %0d", total_tests-passed_tests);

    $stop;

end

endmodule

