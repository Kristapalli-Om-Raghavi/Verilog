`timescale 1ns/1ps

module baud_gen #(
    parameter CLK_FREQ  = 1000000,   // 1MHz Clock
    parameter BAUD_RATE = 9600
)(
    input  wire clk,
    input  wire rst,
    output reg  baud_tick
);

localparam integer BAUD_COUNT = CLK_FREQ / BAUD_RATE;

reg [7:0] counter;

always @(posedge clk or posedge rst)
begin
    if (rst)
    begin
        counter   <= 8'd0;
        baud_tick <= 1'b0;
    end
    else
    begin
        if (counter == BAUD_COUNT-1)
        begin
            counter   <= 8'd0;
            baud_tick <= 1'b1;
        end
        else
        begin
            counter   <= counter + 1'b1;
            baud_tick <= 1'b0;
        end
    end
end

endmodule

