`timescale 1ns/1ps

module baud_gen #(
    parameter CLK_FREQ = 1000000
)(
    input  wire clk,
    input  wire rst,

    input  wire [1:0] baud_select,

    output reg baud_tick
);

reg [15:0] baud_count;
reg [15:0] counter;

always @(*)
begin
    case(baud_select)
        2'b00: baud_count = CLK_FREQ / 9600;
        2'b01: baud_count = CLK_FREQ / 19200;
        2'b10: baud_count = CLK_FREQ / 57600;
        2'b11: baud_count = CLK_FREQ / 115200;
        default: baud_count = CLK_FREQ / 9600;
    endcase
end

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        counter   <= 0;
        baud_tick <= 0;
    end
    else
    begin
        if(counter == baud_count-1)
        begin
            counter   <= 0;
            baud_tick <= 1;
        end
        else
        begin
            counter   <= counter + 1;
            baud_tick <= 0;
        end
    end
end

endmodule
