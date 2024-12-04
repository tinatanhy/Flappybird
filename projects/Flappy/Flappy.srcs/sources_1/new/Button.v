`timescale 1ns / 1ps  

module Button (  
    input wire clk,       // 输入时钟  
    input wire btn,       // 任意按钮型信号
    output pressed, check, released
);  

// 其实就是双边沿检测。
reg btn_r1, btn_r2;
initial begin
    btn_r1 = 1'b0;
    btn_r2 = 1'b0;
end
always @(posedge clk) begin          
    btn_r1 <= btn;  
    btn_r2 <= btn_r1;
end   

assign check    =  btn_r1;
assign pressed  =  btn_r1 & ~btn_r2;
assign released = ~btn_r1 &  btn_r2;
endmodule