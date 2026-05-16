`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.05.2026 18:35:40
// Design Name: 
// Module Name: async_fifo_tb
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


module async_fifo_tb;

reg wclk;
reg rclk;

reg wrst;
reg rrst;

reg wr_en;
reg rd_en;

reg [7:0] data_in;

wire [7:0] data_out;

wire full;
wire empty;


// DUT INSTANTIATION

async_fifo dut (

    .wclk(wclk),
    .rclk(rclk),

    .wrst(wrst),
    .rrst(rrst),

    .wr_en(wr_en),
    .rd_en(rd_en),

    .data_in(data_in),

    .data_out(data_out),

    .full(full),
    .empty(empty)

);


// WRITE CLOCK GENERATION
// 100 MHz -> 10ns period

always #5 wclk = ~wclk;


// READ CLOCK GENERATION
// 50 MHz -> 20ns period

always #10 rclk = ~rclk;



// TEST SEQUENCE

initial
begin

    // INITIAL VALUES

    wclk = 0;
    rclk = 0;

    wrst = 1;
    rrst = 1;

    wr_en = 0;
    rd_en = 0;

    data_in = 0;


    // RESET

    #20;

    wrst = 0;
    rrst = 0;


    // WRITE DATA INTO FIFO

    #10;

    wr_en = 1;

    data_in = 8'h11;

    #10;
    data_in = 8'h22;

    #10;
    data_in = 8'h33;

    #10;
    data_in = 8'h44;

    #10;
    data_in = 8'h55;

    #10;

    wr_en = 0;


    // WAIT SOME TIME

    #40;


    // READ DATA FROM FIFO

    rd_en = 1;

    #80;

    rd_en = 0;


    // SIMULTANEOUS READ & WRITE

    #20;

    wr_en = 1;
    rd_en = 1;

    data_in = 8'hAA;

    #10;
    data_in = 8'hBB;

    #10;
    data_in = 8'hCC;

    #20;

    wr_en = 0;
    rd_en = 0;


    // FILL FIFO

    #20;

    wr_en = 1;

    repeat(20)
    begin
        #10;
        data_in = data_in + 1;
    end

    wr_en = 0;


    // EMPTY FIFO

    #40;

    rd_en = 1;

    repeat(20)
    begin
        #20;
    end

    rd_en = 0;


    // FINISH

    #50;

    $finish;

end



// MONITOR SIGNALS

initial
begin

$monitor("TIME=%0t | wr_en=%b rd_en=%b | data_in=%h data_out=%h | full=%b empty=%b | wptr=%d rptr=%d",

$time,
wr_en,
rd_en,
data_in,
data_out,
full,
empty,
dut.wptr_bin,
dut.rptr_bin

);

end

endmodule
