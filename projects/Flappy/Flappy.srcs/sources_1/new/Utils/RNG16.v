// TODO:
// RNG 16 模块（16 位随机数生成器）：
// 需要达成的效果：
//    每次接收到低电平的 rstn 信号，就将 finish 设置成 0，并生成一个 16 位的随机数。
//    建议查阅网上已有的算法或借助 ip 核，用时序逻辑电路实现。
//    生成完成后将 finish 设置为 1，并将 16 位随机数输出至 rand16 信号中。
// 这个随机数模块用于在*每次游戏开始*时决定管道地图生成的种子、玩家颜色、背景颜色等随机信息。
// 因此每局游戏中，该模块只会复位一次。整局游戏中输出的 rand16 都不会发生改变。
// 一个可能的实现思路是：
//  1. 用一个高速时钟（如 100MHz）作为输入时钟 clk 更新一个 32 位的计数器。
//     这保证了每局游戏开始时这个计数器的值几乎不可能是一样的。 
//  2. 每收到复位信号，就将当前时钟周期的计数器值存进一个寄存器中，作为种子。
//  3. 将种子输入刚才实现的 Hash32to16 模块中，得到一个 16 位的随机数。
//  不过其实，如果 Hash 实现合理，将一个 16 位计数器的值直接输出也是能达到理想的效果的。
//  我们希望玩家颜色、背景颜色对应的位数 [15:13] 更新更快，所以可以将计数器翻转后输出。
//  你可以通过编写 Testbench 测试该模块。

 module RNG16 (  
    input wire clk,              // 输入时钟  
    input wire rstn,            // 复位信号（低电平有效）  
    input wire upd,          // 更新信号，触发随机数生成  
    output reg finish,          // 结束信号  
    output reg [15:0] rand16    // 16位随机数  
);  

    reg [31:0] counter;         // 32位计数器  
    reg [31:0] seed;            // 存储种子  
    reg [31:0] simple_hash;     // 存储较为简单的哈希值  

    // 计数器和状态管理  
    always @(posedge clk) begin  
        if (!rstn) begin  
            // 复位状态  
            simple_hash <= 0;
            finish <= 0;  
            counter <= 32'd0;    // 将计数器初始为 0  
            rand16 <= 16'b0;     // 将 rand16 初始为 0  
            seed <= 32'b0;       // 种子初始为 0  
        end else begin  
                // 仅在`finish`为0时更新计数器和种子  
                counter <= counter + 114513;  
                seed <= counter;  // 将计数器当前值作为种子  
                finish <= 0;
                // 当更新信号有效时，生成随机数  
                simple_hash <= seed; 
                if (upd) begin  
                    // 简单哈希生成  
                    // 设置生成完成信号和生成的随机数  
                    rand16 <= simple_hash[15:0]; // 取低16位作为随机数  
                    finish <= 1;                 // 设置为完成状态  
                end  
                
        end  
    end  

endmodule