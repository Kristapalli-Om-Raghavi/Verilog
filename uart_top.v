`timescale 1ns/1ps

module uart_top #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 16
)
(
    input  wire clk,
    input  wire rst,

    // UART Configuration
    input  wire [1:0] baud_select,
    input  wire [1:0] data_bits_sel,
    input  wire [1:0] parity_sel,
    input  wire       stop_bits_sel,

    // TX FIFO write interface
    input  wire [DATA_WIDTH-1:0] tx_data_in,
    input  wire                  tx_wr_en,
    output wire                  tx_fifo_full,

    // RX FIFO read interface
    output wire [DATA_WIDTH-1:0] rx_data_out,
    input  wire                  rx_rd_en,
    output wire                  rx_fifo_empty,

    // UART serial pins
    output wire tx,
    input  wire rx,

    // Status
    output wire tx_busy,
    output wire tx_done,

    output wire rx_busy,
    output wire rx_done,

    output wire parity_error,
    output wire framing_error
);
//////////////////////////////////////////////////////
// Baud Generator
//////////////////////////////////////////////////////

wire baud_tick;

baud_gen baud_inst(
    .clk(clk),
    .rst(rst),
    .baud_select(baud_select),
    .baud_tick(baud_tick)
);


//////////////////////////////////////////////////////
// TX FIFO Signals
//////////////////////////////////////////////////////

wire [DATA_WIDTH-1:0] tx_fifo_data;
wire tx_fifo_empty;

reg tx_fifo_rd_en;


//////////////////////////////////////////////////////
// RX FIFO Signals
//////////////////////////////////////////////////////

wire [DATA_WIDTH-1:0] rx_fifo_data;
wire rx_fifo_wr_en;

wire [DATA_WIDTH-1:0] rx_data;


//////////////////////////////////////////////////////
// TX FIFO
//////////////////////////////////////////////////////

tx_fifo #(
    .DATA_WIDTH(DATA_WIDTH),
    .FIFO_DEPTH(FIFO_DEPTH)
)
tx_fifo_inst
(
    .clk(clk),
    .rst(rst),

    .wr_en(tx_wr_en),
    .data_in(tx_data_in),

    .rd_en(tx_fifo_rd_en),
    .data_out(tx_fifo_data),

    .full(tx_fifo_full),
    .empty(tx_fifo_empty)
);



//////////////////////////////////////////////////////
// RX FIFO
//////////////////////////////////////////////////////

rx_fifo #(
    .DATA_WIDTH(DATA_WIDTH),
    .FIFO_DEPTH(FIFO_DEPTH)
)
rx_fifo_inst
(
    .clk(clk),
    .rst(rst),

    .wr_en(rx_fifo_wr_en),
    .data_in(rx_data),

    .rd_en(rx_rd_en),
    .data_out(rx_data_out),

    .empty(rx_fifo_empty),
    .full()
);



//////////////////////////////////////////////////////
// UART TX
//////////////////////////////////////////////////////

reg tx_start;

uart_tx tx_inst(

    .clk(clk),
    .rst(rst),

    .baud_tick(baud_tick),

    .tx_start(tx_start),
    .data_in(tx_fifo_data),

    .data_bits_sel(data_bits_sel),
    .parity_sel(parity_sel),
    .stop_bits_sel(stop_bits_sel),

    .tx(tx),

    .tx_busy(tx_busy),
    .tx_done(tx_done)

);

//////////////////////////////////////////////////////
// UART RX
//////////////////////////////////////////////////////




uart_rx rx_inst(

    .clk(clk),
    .rst(rst),

    .baud_tick(baud_tick),

    .rx(rx),

    .data_bits_sel(data_bits_sel),
    .parity_sel(parity_sel),
    .stop_bits_sel(stop_bits_sel),

    .data_out(rx_data),

    .rx_done(rx_done),
    .rx_busy(rx_busy),

    .parity_error(parity_error),
    .framing_error(framing_error)

);
assign rx_fifo_wr_en = rx_done;



//////////////////////////////////////////////////////
// TX FIFO Control Logic
//////////////////////////////////////////////////////

localparam CTRL_IDLE  = 2'd0;
localparam CTRL_READ  = 2'd1;
localparam CTRL_START = 2'd2;
localparam CTRL_WAIT  = 2'd3;

reg [1:0] ctrl_state;

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        ctrl_state    <= CTRL_IDLE;
        tx_fifo_rd_en <= 1'b0;
        tx_start      <= 1'b0;
    end
    else
    begin
        // Default outputs
        tx_fifo_rd_en <= 1'b0;
        tx_start      <= 1'b0;

        case(ctrl_state)

        //--------------------------------------------------
        // Wait until FIFO has data and transmitter is free
        //--------------------------------------------------
        CTRL_IDLE:
        begin
            if(!tx_fifo_empty && !tx_busy)
            begin
                tx_fifo_rd_en <= 1'b1;
                ctrl_state <= CTRL_READ;
            end
        end

        //--------------------------------------------------
        // FIFO outputs data after read pulse
        //--------------------------------------------------
        CTRL_READ:
        begin
            ctrl_state <= CTRL_START;
        end

        //--------------------------------------------------
        // Start UART transmission
        //--------------------------------------------------
        CTRL_START:
        begin
            tx_start <= 1'b1;
            ctrl_state <= CTRL_WAIT;
        end

        //--------------------------------------------------
        // Wait until transmission finishes
        //--------------------------------------------------
        CTRL_WAIT:
        begin
            if(tx_done)
                ctrl_state <= CTRL_IDLE;
        end

        default:
            ctrl_state <= CTRL_IDLE;

        endcase
    end
end
endmodule