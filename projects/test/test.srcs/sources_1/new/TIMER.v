`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/29 22:42:16
// Design Name: 
// Module Name: TIMER
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


module TIMER(
    input clk, rst,
    output [3:0] out,
    output [2:0] select
);

reg [31:0] counter;
reg [3:0] s_0, s_1, m_0, m_1, h;

initial begin
    counter = 1;
    s_0 = 0;
    s_1 = 3;
    m_0 = 8;
    m_1 = 5;
    h   = 9;
end

always @(posedge clk) begin
    if(rst) begin
        counter <= 1;
        s_0 <= 0;
        s_1 <= 3;
        m_0 <= 8;
        m_1 <= 5;
        h   <= 9;
    end
    if(counter == 100_000_000) begin
        counter <= 1;
        if(s_0 == 9) begin
            s_0 <= 0;
            if(s_1 == 5) begin
                s_1 <= 0;
                if(m_0 == 9) begin
                    m_0 <= 0;
                    if(m_1 == 5) begin
                        m_1 <= 0;
                        h <= h + 1;
                    end else m_1 <= m_1 + 1;
                end else m_0 <= m_0 + 1;
            end else s_1 <= s_1 + 1;
        end else s_0 <= s_0 + 1;
    end else counter <= counter + 1;
end

Segment segment(
    .clk                (clk),
    .rst                (rst),
    .output_data        ({0, 0, 0, h, m_1, m_0, s_1, s_0}),
    .mask               (8'hFF),    
    .seg_data           (out),
    .seg_an             (select)
);
endmodule