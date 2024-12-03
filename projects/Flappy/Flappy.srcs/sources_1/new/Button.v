`timescale 1ns / 1ps
module clk_divider (  
    input wire clk_in,      // 输入的 100 MHz 时钟  
    input wire rst,         // 复位信号  
    output reg clk_out      // 输出的 72 Hz 时钟  
);  

    reg [20:0] counter;     // 计数器，21 位足够用来计算 1388888  
    parameter DIVISOR = 1388888; // 分频系数 - 100MHz/72Hz  

    always @(posedge clk_in or posedge rst) begin  
        if (rst) begin  
            counter <= 0;  
            clk_out <= 0;  
        end else if (counter == DIVISOR - 1) begin  
            counter <= 0;           // 重置计数器  
            clk_out <= ~clk_out;    // 翻转输出时钟  
        end else begin  
            counter <= counter + 1; // 计数器加一  
        end  
    end  
endmodule  
module Button (  
    input wire clk,       
    input wire BTNC,     
    input wire BTNU,    
    input wire BTNL,     
    output reg [2:0] LED

);  
    reg last_state_C = 0;   
    reg last_state_U = 0;  
    reg last_state_L = 0; 

    parameter DEBOUNCE_LIMIT = 4'd10; // 去抖动计数限制  

    always @(posedge clk) begin  
        LED[1] <= 1;  
        LED[0] <= BTNC; 
        if (BTNU == last_state_U) begin  
            debounce_counter_U <= 0;  
        end else begin  
            if (debounce_counter_U < DEBOUNCE_LIMIT) begin  
                debounce_counter_U <= debounce_counter_U + 1;  
            end else begin  
               
            end  
        end  
        last_state_U <= BTNU;  

 
        if (BTNL == last_state_L) begin  
            debounce_counter_L <= 0;  
        end else begin  
            if (debounce_counter_L < DEBOUNCE_LIMIT) begin  
                debounce_counter_L <= debounce_counter_L + 1;  
            end else begin  
                LED[2] <= BTNL; 
            end  
        end  
        last_state_L <= BTNL;  
    end  
endmodule
