`timescale 1ns / 1ps

module rx_fifo #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 16
)(
    input  wire                   clk,
    input  wire                   rst,

    // Write Interface (from UART Receiver)
    input  wire                   wr_en,
    input  wire [DATA_WIDTH-1:0]  data_in,

    // Read Interface (to Top Module/User)
    input  wire                   rd_en,
    output reg  [DATA_WIDTH-1:0]  data_out,

    // Status Flags
    output wire                   full,
    output wire                   empty
);

reg [DATA_WIDTH-1:0] fifo_mem [0:FIFO_DEPTH-1];

reg [3:0] wr_ptr;
reg [3:0] rd_ptr;
reg [4:0] count;

assign full  = (count == FIFO_DEPTH);
assign empty = (count == 0);

integer i;

always @(posedge clk or posedge rst)
begin
    if (rst)
    begin
        wr_ptr   <= 4'd0;
        rd_ptr   <= 4'd0;
        count    <= 5'd0;
        data_out <= {DATA_WIDTH{1'b0}};

        for(i = 0; i < FIFO_DEPTH; i = i + 1)
            fifo_mem[i] <= {DATA_WIDTH{1'b0}};
    end
    else
    begin
        case ({wr_en && !full, rd_en && !empty})

            // Write only
            2'b10:
            begin
                fifo_mem[wr_ptr] <= data_in;
                wr_ptr <= wr_ptr + 1'b1;
                count  <= count + 1'b1;
            end

            // Read only
            2'b01:
            begin
                data_out <= fifo_mem[rd_ptr];
                rd_ptr   <= rd_ptr + 1'b1;
                count    <= count - 1'b1;
            end

            // Simultaneous Read and Write
            2'b11:
            begin
                fifo_mem[wr_ptr] <= data_in;
                data_out <= fifo_mem[rd_ptr];
                wr_ptr <= wr_ptr + 1'b1;
                rd_ptr <= rd_ptr + 1'b1;
                // count remains unchanged
            end

            // No operation
            default:
            begin
                // Do nothing
            end

        endcase
    end
end

endmodule