`timescale 1ns / 1ps

module uart_tx
(
    input  wire        clk,
    input  wire        rst,

    // Baud tick from baud generator
    input  wire        baud_tick,

    // Transmission control
    input  wire        tx_start,
    input  wire [7:0]  data_in,

    // Configuration
    input  wire [1:0]  data_bits_sel,   //00=5,01=6,10=7,11=8
    input  wire [1:0]  parity_sel,      //00=None,01=Even,10=Odd
    input  wire        stop_bits_sel,   //0=1 stop,1=2 stop

    // UART TX
    output reg         tx,

    // Status
    output reg         tx_busy,
    output reg         tx_done
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

    reg [7:0] tx_data;

    reg [3:0] total_data_bits;
    reg [2:0] bit_count;

    reg       parity_bit;
    reg       parity_enable;

    reg       stop_count;

    //----------------------------------------------------------
    // Decode Number of Data Bits
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
    // UART TX FSM
    //----------------------------------------------------------
    always @(posedge clk or posedge rst)
    begin

        if(rst)
        begin
            state       <= IDLE;
            tx          <= 1'b1;

            tx_busy     <= 1'b0;
            tx_done     <= 1'b0;

            tx_data     <= 8'd0;

            bit_count   <= 3'd0;
            parity_bit  <= 1'b0;
            parity_enable <= 1'b0;

            stop_count  <= 1'b0;
        end

        else
        begin

            tx_done <= 1'b0;

            case(state)

            /////////////////////////////////////////////////////
            // IDLE
            /////////////////////////////////////////////////////
            IDLE:
            begin
                tx <= 1'b1;
                tx_busy <= 1'b0;

                if(tx_start)
                begin
                    tx_busy <= 1'b1;

                    tx_data <= data_in;

                    bit_count <= 3'd0;
                    stop_count <= 1'b0;

                    //--------------------------------------------------
                    // Enable parity
                    //--------------------------------------------------
                    if(parity_sel == 2'b00)
                        parity_enable <= 1'b0;
                    else
                        parity_enable <= 1'b1;

                    //--------------------------------------------------
                    // Compute parity only once
                    //--------------------------------------------------
                    case(data_bits_sel)

                        2'b00:
                        begin
                            if(parity_sel==2'b01)
                                parity_bit <= ^data_in[4:0];
                            else
                                parity_bit <= ~(^data_in[4:0]);
                        end

                        2'b01:
                        begin
                            if(parity_sel==2'b01)
                                parity_bit <= ^data_in[5:0];
                            else
                                parity_bit <= ~(^data_in[5:0]);
                        end

                        2'b10:
                        begin
                            if(parity_sel==2'b01)
                                parity_bit <= ^data_in[6:0];
                            else
                                parity_bit <= ~(^data_in[6:0]);
                        end

                        default:
                        begin
                            if(parity_sel==2'b01)
                                parity_bit <= ^data_in[7:0];
                            else
                                parity_bit <= ~(^data_in[7:0]);
                        end

                    endcase

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
                    tx <= 1'b0;
                    state <= DATA;
                end
            end

            /////////////////////////////////////////////////////
            // DATA BITS
            /////////////////////////////////////////////////////
            DATA:
            begin
                if(baud_tick)
                begin
                    tx <= tx_data[bit_count];

                    if(bit_count == total_data_bits-1)
                    begin
                        bit_count <= 3'd0;

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
            // PARITY
            /////////////////////////////////////////////////////
            PARITY:
            begin
                if(baud_tick)
                begin
                    tx <= parity_bit;
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
                    tx <= 1'b1;

                    if(stop_bits_sel)
                    begin
                        if(stop_count==0)
                        begin
                            stop_count <= 1'b1;
                        end
                        else
                        begin
                            stop_count <= 1'b0;
                            state <= IDLE;
                            tx_done <= 1'b1;
                            tx_busy <= 1'b0;
                        end
                    end
                    else
                    begin
                        state <= IDLE;
                        tx_done <= 1'b1;
                        tx_busy <= 1'b0;
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