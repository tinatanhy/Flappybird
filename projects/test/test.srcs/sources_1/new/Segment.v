`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/23 18:53:04
// Design Name: 
// Module Name: Segment
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


module Segment(
    input                   clk,
    input                   rst,
    input       [ 7:0]      mask,
    input       [31:0]      output_data,
    output  reg [ 3:0]      seg_data,
    output  reg [ 2:0]      seg_an
);

reg [ 2:0] seg_id;
reg [31:0] counter;

initial begin
    seg_id   = 0;
    seg_an   = 0;
    counter  = 0;
    seg_data = output_data[3:0];
end

always @(posedge clk) begin
    if (rst) begin
        seg_id   <= 0;
        counter  <= 0;
    end
    else begin
        counter <= counter + 1;
        if (counter == 25000) begin
            seg_id <= seg_id + 1;
            counter <= 1;
        end
    end
end

always @(*) begin
    if(mask[seg_id] == 1'b1) begin
        seg_an = seg_id;
        seg_data = output_data[seg_id * 4 +: 4];
    end 
    else begin
        seg_an = 0;
        seg_data = output_data[3:0];
    end
end

endmodule

