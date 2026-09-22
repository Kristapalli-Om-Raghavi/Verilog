`timescale 1ns/1ps

module uart_rx
(
    input  wire        clk,
    input  wire        rst,

    // Baud tick from baud generator
    input  wire        baud_tick,

    // UART RX line
    input  wire        rx,

    // Configuration
    input  wire [1:0]  data_bits_sel,   //00=5,01=6,10=7,11=8
    input  wire [1:0]  parity_sel,      //00=None,01=Even,10=Odd
    input  wire        stop_bits_sel,   //0=1 stop,1=2 stop

    // Received data
    output reg [7:0]   data_out,

    // Status
    output reg         rx_done,
    output reg         rx_busy,

    // Error flags
    output reg         parity_error,
    output reg         framing_error
);

    //----------------------------------------------------------
    // State Encoding
    //----------------------------------------------------------
    localparam IDLE   = 3'd0;
    localparam START  = 3'd1;
    localparam DATA   = 3'd2;
    localparam PARITY = 3'd3;
    localparam STOP   = 3'd4;

    //----------------------------------------------------------
    // Registers
    //----------------------------------------------------------
    reg [2:0] state;

    reg [7:0] rx_data;

    reg [3:0] total_data_bits;
    reg [2:0] bit_count;

    reg received_parity;
    reg expected_parity;

    reg parity_enable;

    reg stop_count;

    //----------------------------------------------------------
    // Decode data bits
    //----------------------------------------------------------
    always @(*)
    begin
        case(data_bits_sel)
            2'b00: total_data_bits = 4'd5;
            2'b01: total_data_bits = 4'd6;
            2'b10: total_data_bits = 4'd7;
            default: total_data_bits = 4'd8;
        endcase
    end

    //----------------------------------------------------------
    // UART RX FSM
    //----------------------------------------------------------
    always @(posedge clk or posedge rst)
    begin

        if(rst)
        begin
            state <= IDLE;

            rx_done <= 0;
            rx_busy <= 0;

            data_out <= 0;
            rx_data <= 0;

            bit_count <= 0;
            stop_count <= 0;

            parity_enable <= 0;

            parity_error <= 0;
            framing_error <= 0;

            received_parity <= 0;
            expected_parity <= 0;
        end

        else
        begin

            rx_done <= 0;

            case(state)

            /////////////////////////////////////////////////////
            // IDLE
            /////////////////////////////////////////////////////
            IDLE:
            begin
                rx_busy <= 0;

                if(rx==0)
                begin
                    rx_busy <= 1;

                    bit_count <= 0;
                    stop_count <= 0;

                    parity_error <= 0;
                    framing_error <= 0;

                    parity_enable <= (parity_sel!=2'b00);

                    state <= START;
                end
            end

            /////////////////////////////////////////////////////
            // START BIT
            /////////////////////////////////////////////////////
            START:
            begin
                if(baud_tick)
                begin
                    if(rx==0)
                        state <= DATA;
                    else
                        state <= IDLE;
                end
            end

            /////////////////////////////////////////////////////
            // RECEIVE DATA
            /////////////////////////////////////////////////////
            DATA:
            begin
                if(baud_tick)
                begin
                    rx_data[bit_count] <= rx;

                    if(bit_count == total_data_bits-1)
                    begin
                        bit_count <= 0;

                        if(parity_enable)
                            state <= PARITY;
                        else
                            state <= STOP;
                    end
                    else
                    begin
                        bit_count <= bit_count + 1'b1;
                    end
                end
            end

            /////////////////////////////////////////////////////
            // RECEIVE PARITY
            /////////////////////////////////////////////////////
            PARITY:
begin
    if (baud_tick)
    begin
        // Calculate expected parity
        case (data_bits_sel)
            2'b00:
                expected_parity = (parity_sel == 2'b01) ? ^rx_data[4:0] : ~(^rx_data[4:0]);

            2'b01:
                expected_parity = (parity_sel == 2'b01) ? ^rx_data[5:0] : ~(^rx_data[5:0]);

            2'b10:
                expected_parity = (parity_sel == 2'b01) ? ^rx_data[6:0] : ~(^rx_data[6:0]);

            default:
                expected_parity = (parity_sel == 2'b01) ? ^rx_data[7:0] : ~(^rx_data[7:0]);
        endcase

        received_parity <= rx;

        if (rx != expected_parity)
            parity_error <= 1'b1;

        state <= STOP;
    end
end

            /////////////////////////////////////////////////////
            // STOP BIT(S)
            /////////////////////////////////////////////////////
            STOP:
            begin
                if(baud_tick)
                begin
                    if(rx!=1'b1)
                        framing_error <= 1'b1;

                    if(stop_bits_sel)
                    begin
                        if(stop_count==0)
                        begin
                            stop_count <= 1'b1;
                        end
                        else
                        begin
                            data_out <= rx_data;
                            rx_done <= 1'b1;
                            rx_busy <= 1'b0;
                            stop_count <= 0;
                            state <= IDLE;
                        end
                    end
                    else
                    begin
                        data_out <= rx_data;
                        rx_done <= 1'b1;
                        rx_busy <= 1'b0;
                        state <= IDLE;
                    end
                end
            end

            default:
            begin
                state <= IDLE;
            end

            endcase

        end

    end

endmodule