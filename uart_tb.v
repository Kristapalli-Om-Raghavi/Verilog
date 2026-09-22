`timescale 1ns/1ps

module uart_tb;
reg [1:0] baud_select;
reg [1:0] data_bits_sel;
reg [1:0] parity_sel;
reg       stop_bits_sel;

// UART status signals
wire tx_busy;
wire tx_done;
wire rx_busy;
wire rx_done;
wire parity_error;
wire framing_error;

//////////////////////////////////////////////////////
// Clock and Reset
//////////////////////////////////////////////////////

reg clk;
reg rst;
initial
begin

    baud_select   = 2'b01;
    data_bits_sel = 2'b11;
    parity_sel    = 2'b00;
    stop_bits_sel = 1'b0;

end
always #10 clk = ~clk;     // 50MHz clock


//////////////////////////////////////////////////////
// TX FIFO Interface
//////////////////////////////////////////////////////

reg [7:0] tx_data_in;
reg tx_wr_en;
wire tx_fifo_full;


//////////////////////////////////////////////////////
// RX FIFO Interface
//////////////////////////////////////////////////////

wire [7:0] rx_data_out;
reg rx_rd_en;
wire rx_fifo_empty;


//////////////////////////////////////////////////////
// UART Signals
//////////////////////////////////////////////////////

wire tx;
wire rx;



// Loopback connection
assign rx = tx;



//////////////////////////////////////////////////////
// DUT
//////////////////////////////////////////////////////

uart_top dut
(
    .clk(clk),
    .rst(rst),

    // Configuration
    .baud_select(baud_select),
    .data_bits_sel(data_bits_sel),
    .parity_sel(parity_sel),
    .stop_bits_sel(stop_bits_sel),

    // TX FIFO
    .tx_data_in(tx_data_in),
    .tx_wr_en(tx_wr_en),
    .tx_fifo_full(tx_fifo_full),

    // RX FIFO
    .rx_data_out(rx_data_out),
    .rx_rd_en(rx_rd_en),
    .rx_fifo_empty(rx_fifo_empty),

    // UART
    .tx(tx),
    .rx(rx),

    // Status
    .tx_busy(tx_busy),
    .tx_done(tx_done),
    .rx_busy(rx_busy),
    .rx_done(rx_done),
    .parity_error(parity_error),
    .framing_error(framing_error)
);

//////////////////////////////////////////////////////
// Test Sequence
//////////////////////////////////////////////////////

initial
begin

    clk = 0;

    rst = 1;

    tx_wr_en = 0;
    rx_rd_en = 0;

    tx_data_in = 8'h00;


    // Reset
    #100;

    rst = 0;


    //////////////////////////////////////////////////////
    // Write Multiple Bytes into TX FIFO
    //////////////////////////////////////////////////////


    send_byte(8'hA5);

    send_byte(8'h3C);

    send_byte(8'h55);

    send_byte(8'hF0);



    //////////////////////////////////////////////////////
    // Wait for UART transmission
    //////////////////////////////////////////////////////

    #5000000;



    //////////////////////////////////////////////////////
    // Read RX FIFO
    //////////////////////////////////////////////////////


    read_byte();

    read_byte();

    read_byte();

    read_byte();



    #1000;


    $finish;

end



//////////////////////////////////////////////////////
// Task : Write TX FIFO
//////////////////////////////////////////////////////

task send_byte(input [7:0] data);

begin

    @(posedge clk);

    tx_data_in <= data;

    tx_wr_en <= 1'b1;


    @(posedge clk);

    tx_wr_en <= 1'b0;


    $display("TX FIFO WRITE : DATA = %h TIME = %0t",
              data,$time);

end

endtask




//////////////////////////////////////////////////////
// Task : Read RX FIFO
//////////////////////////////////////////////////////

task read_byte;

begin

    wait(rx_fifo_empty == 0);


    @(posedge clk);

    rx_rd_en <= 1'b1;

#20;
    @(posedge clk);

    rx_rd_en <= 1'b0;


    $display("RX FIFO READ  : DATA = %h TIME = %0t",
              rx_data_out,$time);

end

endtask




//////////////////////////////////////////////////////
// Monitor
//////////////////////////////////////////////////////

initial
begin
    $monitor(
    "TIME=%0t TX=%b RX=%b TX_BUSY=%b RX_BUSY=%b TX_DONE=%b RX_DONE=%b RX_FIFO_EMPTY=%b RX_DATA=%h",
    $time,
    tx,
    rx,
    tx_busy,
    rx_busy,
    tx_done,
    rx_done,
    rx_fifo_empty,
    rx_data_out
    );
end
endmodule
