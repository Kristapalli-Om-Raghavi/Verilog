`timescale 1ns / 1ps

module uart_tx(
    input  wire       clk,
    input  wire       rst,
    input  wire       baud_tick,
    input  wire       tx_start,
    input  wire [7:0] data_in,
    output reg        tx,
    output reg        tx_done
);

reg [7:0] tx_data;
reg [3:0] bit_count;
reg [1:0] state;

parameter IDLE  = 2'b00;
parameter START = 2'b01;
parameter DATA  = 2'b10;
parameter STOP  = 2'b11;

always @(posedge clk or posedge rst)
begin
    if (rst)
    begin
        state     <= IDLE;
        tx         <= 1'b1;
        tx_done    <= 1'b0;
        tx_data    <= 8'd0;
        bit_count  <= 4'd0;
    end
    else
    begin
        // Default
        tx_done <= 1'b0;

        case(state)

        //-------------------------------------------------
        // IDLE : Wait for transmit request
        //-------------------------------------------------
        IDLE:
        begin
            tx <= 1'b1;

            if(tx_start)
            begin
                tx_data   <= data_in;
                bit_count <= 4'd0;
                state     <= START;
            end
        end

        //-------------------------------------------------
        // START BIT
        //-------------------------------------------------
        START:
        begin
            if(baud_tick)
            begin
                tx    <= 1'b0;
                state <= DATA;
            end
        end

        //-------------------------------------------------
        // DATA BITS
        //-------------------------------------------------
        DATA:
        begin
            if(baud_tick)
            begin
                tx      <= tx_data[0];
                tx_data <= tx_data >> 1;

                if(bit_count == 7)
                    state <= STOP;
                else
                    bit_count <= bit_count + 1;
            end
        end

        //-------------------------------------------------
        // STOP BIT
        //-------------------------------------------------
        STOP:
        begin
            if(baud_tick)
            begin
                tx      <= 1'b1;
                tx_done <= 1'b1;
                state   <= IDLE;
            end
        end

        default:
            state <= IDLE;

        endcase
    end
end

endmodule
