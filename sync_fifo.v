`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.05.2026 16:01:27
// Design Name: 
// Module Name: sync_fifo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sync_fifo (

    input clk,
    input reset,
    input wr_en,
    input rd_en,
    input [7:0] data_in,

    output reg [7:0] data_out,
    output full,
    output empty

);

reg [7:0] mem [0:15];

reg [3:0] wr_ptr;
reg [3:0] rd_ptr;

reg [4:0] count;

assign full  = (count == 16);
assign empty = (count == 0);

always @(posedge clk or posedge reset)
begin

    if(reset)
    begin
        wr_ptr <= 0;
        rd_ptr <= 0;
        count <= 0;
        data_out <= 0;
    end

    else
    begin

        // WRITE OPERATION
        if(wr_en && !full)
        begin
            mem[wr_ptr] <= data_in;
            wr_ptr <= wr_ptr + 1;
        end

        // READ OPERATION
        if(rd_en && !empty)
        begin
            data_out <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
        end

        // COUNT LOGIC

        case ({wr_en && !full, rd_en && !empty})

            2'b10: count <= count + 1;

            2'b01: count <= count - 1;

            2'b11: count <= count;

            default: count <= count;

        endcase

    end

end

endmodule
