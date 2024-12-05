`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/05 09:55:12
// Design Name: 
// Module Name: hash_tb
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


`timescale 1ns / 1ps  

module tb_Hash32to16;  

    // 参数定义  
    reg clk;  
    reg rstn;  
    reg start;  
    reg [31:0] seed;  
    wire finish;  
    wire [15:0] hash;  

    // 实例化要测试的模块  
    Hash32to16 hash_module (  
        .clk(clk),  
        .rstn(rstn),  
        .start(start),  
        .seed(seed),  
        .finish(finish),  
        .hash(hash)  
    );  

    // 时钟生成  
    initial begin  
        clk = 0;  
        forever #5 clk = ~clk;  // 10 ns 时钟周期  
    end  

    // 初始化信号  
    initial begin  
        // 初始化所有信号  
        rstn = 0;  
        start = 0;  
        seed = 32'b0;  

        // 进行复位  
        #10 rstn = 1;  // 释放复位  
        #10;  

        // 测试种子 1  
        seed = 32'hDEADBEEF;  // 32 位种子  
        start = 1;  // 触发哈希计算  
        #10 start = 0;  // 停止启动信号  
        #50; // 等待一段时间  

        // 测试种子 2  
        seed = 32'hCAFEBABE;  // 另一个种子  
        start = 1;  
        #10 start = 0;  
        #50;  

        // 测试种子 3  
        seed = 32'h12345678;  // 再一个种子  
        start = 1;  
        #10 start = 0;  
        #50;  

        // 测试完成所有情况，结束仿真  
        $finish;  
    end  

    // 监视输出信号  
    initial begin  
        $monitor("Time: %0t | Seed: %h | Hash: %h | Finish: %b",   
                 $time, seed, hash, finish);  
    end  

endmodule
