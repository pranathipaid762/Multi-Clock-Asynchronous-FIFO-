`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.05.2026 16:32:43
// Design Name: 
// Module Name: sync_fifo_tb
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


module sync_fifo_tb;

reg clk;
reg reset;
reg wr_en;
reg rd_en;
reg [7:0] data_in;

wire [7:0] data_out;
wire full;
wire empty;


// DUT INSTANTIATION

sync_fifo dut (

    .clk(clk),
    .reset(reset),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .data_in(data_in),

    .data_out(data_out),
    .full(full),
    .empty(empty)

);


// CLOCK GENERATION

always #5 clk = ~clk;


// TEST SEQUENCE

initial
begin

    clk = 0;
    reset = 1;
    wr_en = 0;
    rd_en = 0;
    data_in = 0;

    // RESET

    #10;
    reset = 0;

    // WRITE OPERATION

    #10;
    wr_en = 1;
    data_in = 8'h11;

    #10;
    data_in = 8'h22;

    #10;
    data_in = 8'h33;

    #10;
    wr_en = 0;

    // READ OPERATION

    #10;
    rd_en = 1;

    #30;
    rd_en = 0;

    // SIMULTANEOUS READ & WRITE

    #10;
    wr_en = 1;
    rd_en = 1;
    data_in = 8'h44;

    #10;
    data_in = 8'h55;

    #10;
    wr_en = 0;
    rd_en = 0;

    // FILL FIFO

    #10;
    wr_en = 1;

    repeat(16)
    begin
        #10;
        data_in = data_in + 1;
    end

    wr_en = 0;

    // EMPTY FIFO

    #10;
    rd_en = 1;

    repeat(16)
    begin
        #10;
    end

    rd_en = 0;

    // FINISH SIMULATION

    #20;
    $finish;

end


// MONITOR

initial
begin

    $monitor("TIME=%0t reset=%b wr_en=%b rd_en=%b data_in=%h data_out=%h full=%b empty=%b count=%d",
              $time, reset, wr_en, rd_en, data_in, data_out, full, empty, dut.count);

end

endmodule
