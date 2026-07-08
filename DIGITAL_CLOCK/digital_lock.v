`timescale 1ns / 1ps

module digital_lock(
    input clk,
    input rst,
    input enter,
    input [3:0] password,
    output reg unlock,
    output reg alarm
);

parameter IDLE   = 2'b00;
parameter CHECK  = 2'b01;
parameter OPEN   = 2'b10;
parameter LOCKED = 2'b11;

parameter PASS = 4'b1010;

reg [1:0] state;
reg [1:0] next_state;
reg [1:0] attempts;

// State Register
always @(posedge clk or posedge rst)
begin
    if(rst)
        state <= IDLE;
    else
        state <= next_state;
end

// Next State Logic
always @(*)
begin
    case(state)

        IDLE:
        begin
            if(enter)
                next_state = CHECK;
            else
                next_state = IDLE;
        end

        CHECK:
        begin
            if(password == PASS)
                next_state = OPEN;
            else if(attempts == 2)
                next_state = LOCKED;
            else
                next_state = IDLE;
        end

        OPEN:
            next_state = IDLE;

        LOCKED:
            next_state = LOCKED;

        default:
            next_state = IDLE;

    endcase
end

// Output and Counter Logic
always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        unlock <= 0;
        alarm <= 0;
        attempts <= 0;
    end
    else
    begin
        case(state)

            IDLE:
            begin
                unlock <= 0;
            end

            CHECK:
            begin
                if(password == PASS)
                begin
                    unlock <= 1;
                    alarm <= 0;
                    attempts <= 0;
                end
                else
                begin
                    unlock <= 0;
                    attempts <= attempts + 1;
                end
            end

            OPEN:
            begin
                unlock <= 1;
            end

            LOCKED:
            begin
                unlock <= 0;
                alarm <= 1;
            end

        endcase
    end
end

endmodule
