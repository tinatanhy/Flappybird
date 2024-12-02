`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/29 22:54:09
// Design Name: 
// Module Name: TIMER_tb
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


module tb_TIMER;

// TIMER Parameters
parameter PERIOD  = 10;

reg clk = 0;
reg rst = 1;

// TIMER Outputs
wire [3:0] out;
wire [2:0] select;

initial begin
    forever #(PERIOD/2)  clk=~clk;
end

initial begin
    #(PERIOD*2) rst = 0;
end

TIMER  u_TIMER (
    .clk     (clk),
    .rst     (rst),

    .out     (out),
    .select  (select)
);


endmodule