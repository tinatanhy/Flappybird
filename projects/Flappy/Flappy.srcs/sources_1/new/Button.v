`timescale 1ns / 1ps  

module Button (  
    input wire clk,       // 输入时钟  
    input wire BTNC,      // 中间按钮  
    output reg pressed,   // 按钮被按下的状态  
    output reg check,     // 按钮当前状态  
    output reg released    // 按钮被释放的状态  
);  
    reg BTNC_last;        // 用于存储上一个按钮状态  

    always @(posedge clk) begin          
        check <= BTNC;   
               
        if (BTNC && !BTNC_last) begin   
            pressed <= 1;   
        end else begin  
            pressed <= 0;   
        end      

        if (!BTNC && BTNC_last) begin   
            released <= 1;   
        end else begin  
            released <= 0;   
        end   
        BTNC_last <= BTNC;  
    end   
endmodule