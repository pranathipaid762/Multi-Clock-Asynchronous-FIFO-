`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.05.2026 18:34:19
// Design Name: 
// Module Name: async_fifo
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


module async_fifo (

    input wclk,
    input rclk,

    input wrst,
    input rrst,

    input wr_en,
    input rd_en,

    input [7:0] data_in,

    output reg [7:0] data_out,

    output full,
    output empty

);

// FIFO MEMORY

reg [7:0] mem [0:15];


// BINARY POINTERS

reg [4:0] wptr_bin;
reg [4:0] rptr_bin;


// GRAY POINTERS

reg [4:0] wptr_gray;
reg [4:0] rptr_gray;


// SYNCHRONIZED POINTERS

reg [4:0] wptr_gray_sync1;
reg [4:0] wptr_gray_sync2;

reg [4:0] rptr_gray_sync1;
reg [4:0] rptr_gray_sync2;


// NEXT POINTERS

wire [4:0] wptr_bin_next;
wire [4:0] rptr_bin_next;

wire [4:0] wptr_gray_next;
wire [4:0] rptr_gray_next;


// WRITE POINTER NEXT LOGIC

assign wptr_bin_next =
       wptr_bin + (wr_en && !full);

assign wptr_gray_next =
       (wptr_bin_next >> 1) ^ wptr_bin_next;


// READ POINTER NEXT LOGIC

assign rptr_bin_next =
       rptr_bin + (rd_en && !empty);

assign rptr_gray_next =
       (rptr_bin_next >> 1) ^ rptr_bin_next;


// WRITE DOMAIN LOGIC

always @(posedge wclk or posedge wrst)
begin

    if(wrst)
    begin
        wptr_bin  <= 0;
        wptr_gray <= 0;
    end

    else
    begin

        if(wr_en && !full)
        begin
            mem[wptr_bin[3:0]] <= data_in;
        end

        wptr_bin  <= wptr_bin_next;
        wptr_gray <= wptr_gray_next;

    end

end


// READ DOMAIN LOGIC

always @(posedge rclk or posedge rrst)
begin

    if(rrst)
    begin
        rptr_bin  <= 0;
        rptr_gray <= 0;
        data_out  <= 0;
    end

    else
    begin

        if(rd_en && !empty)
        begin
            data_out <= mem[rptr_bin[3:0]];
        end

        rptr_bin  <= rptr_bin_next;
        rptr_gray <= rptr_gray_next;

    end

end


// SYNCHRONIZER : READ POINTER INTO WRITE CLOCK DOMAIN

always @(posedge wclk or posedge wrst)
begin

    if(wrst)
    begin
        rptr_gray_sync1 <= 0;
        rptr_gray_sync2 <= 0;
    end

    else
    begin
        rptr_gray_sync1 <= rptr_gray;
        rptr_gray_sync2 <= rptr_gray_sync1;
    end

end


// SYNCHRONIZER : WRITE POINTER INTO READ CLOCK DOMAIN

always @(posedge rclk or posedge rrst)
begin

    if(rrst)
    begin
        wptr_gray_sync1 <= 0;
        wptr_gray_sync2 <= 0;
    end

    else
    begin
        wptr_gray_sync1 <= wptr_gray;
        wptr_gray_sync2 <= wptr_gray_sync1;
    end

end


// EMPTY LOGIC

assign empty =
       (rptr_gray_next == wptr_gray_sync2);


// FULL LOGIC

assign full =
       (wptr_gray_next ==
       {~rptr_gray_sync2[4:3],
         rptr_gray_sync2[2:0]});

endmodule
