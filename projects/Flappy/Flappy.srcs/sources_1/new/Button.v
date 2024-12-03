`timescale 1ns / 1ps  

module Button (  
    input wire clk,       // 输入时钟  
    input wire BTNC,      // 中间按钮  
    output reg [2:0] LED  // LED 输出  
);  
    reg BTNC_last;        // 用于存储上一个按钮状态  

    always @(posedge clk) begin  
        // 更新 LED[0]，反映按钮状态  
        LED[0] <= BTNC;   
        
        // 检测 BTNC 的上升沿  
        if (BTNC && !BTNC_last) begin   
            LED[2] <= 1;   // 在上升沿时点亮 LED[2]  
        end else begin  
            LED[2] <= 0;   // 其他情况下熄灭 LED[2]  
        end  
        
        // 检测 BTNC 的下降沿  
        if (!BTNC && BTNC_last) begin   
            LED[1] <= 1;   // 在下降沿时点亮 LED[1]  
        end else begin  
            LED[1] <= 0;   // 其他情况下熄灭 LED[1]  
        end  
        
        // 更新上一个按钮状态  
        BTNC_last <= BTNC;  
    end   
endmodule
