`timescale 1ns / 1ps

module uart_top(
    input wire clk,
    input wire rst,
    input wire tx_start,
    input wire [7:0] data_in,

    output wire tx,
    output wire tx_done,

    output wire [7:0] data_out,
    output wire rx_done
);

wire baud_tick;

// Baud Rate Generator
baud_gen baud_generator (
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick)
);

// UART Transmitter
uart_tx transmitter (
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick),
    .tx_start(tx_start),
    .data_in(data_in),
    .tx(tx),
    .tx_done(tx_done)
);

// UART Receiver
uart_rx receiver (
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick),
    .rx(tx),          // Loopback connection
    .data_out(data_out),
    .rx_done(rx_done)
);

endmodule
