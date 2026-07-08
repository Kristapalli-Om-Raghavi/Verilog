`timescale 1ns/1ps

module uart_rx(
    input wire clk,
    input wire rst,
    input wire baud_tick,
    input wire rx,

    output reg [7:0] data_out,
    output reg rx_done
);

reg [7:0] rx_data;
reg [3:0] bit_count;
reg [1:0] state;

parameter IDLE  = 2'b00;
parameter START = 2'b01;
parameter DATA  = 2'b10;
parameter STOP  = 2'b11;

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        state     <= IDLE;
        data_out  <= 8'd0;
        rx_data   <= 8'd0;
        bit_count <= 4'd0;
        rx_done   <= 1'b0;
    end
    else
    begin
        rx_done <= 1'b0;

        case(state)

        //---------------------------------
        // Wait for Start Bit
        //---------------------------------
        IDLE:
        begin
            if(rx == 1'b0)
                state <= START;
        end

        //---------------------------------
        // Wait one baud tick
        //---------------------------------
        START:
        begin
            if(baud_tick)
            begin
                bit_count <= 0;
                state <= DATA;
            end
        end

        //---------------------------------
        // Receive 8 bits
        //---------------------------------
        DATA:
        begin
            if(baud_tick)
            begin
                rx_data[bit_count] <= rx;

                if(bit_count == 7)
                    state <= STOP;
                else
                    bit_count <= bit_count + 1;
            end
        end

        //---------------------------------
        // Stop Bit
        //---------------------------------
        STOP:
        begin
            if(baud_tick)
            begin
                data_out <= rx_data;
                rx_done <= 1'b1;
                state <= IDLE;
            end
        end

        default:
            state <= IDLE;

        endcase
    end
end

endmodule
