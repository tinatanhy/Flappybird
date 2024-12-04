module Hash32to16(
    input clk,
    input rstn,
    input start,
    input [31:0] seed,      // 32 位种子
    output finish,          // 生成完成信号
    output [15:0] hash      // 16 位哈希值
);
// TODO:
// Hash 32 to 16 模块（32 位到 16 位哈希函数）：
// 需要达成的效果：
//    每次接收到 start 信号，就将 finish 设置成 0，并将 32 位种子 seed 输入。
//    我们需要在这里实现一个哈希函数（可以搜索）：
//    - 输出值仅由 seed 决定，且 seed 的微小变化应该会导致输出值的大变化。
//    - 输出值需要均匀分布在 16 位的范围内。
//    具体的实现方案可以参考网上已有的算法，或者借助 ip 核。
//    因为允许采用时序逻辑电路实现，所以可以引用自己编写的乘法器等。
//    生成完成后将 finish 设置为 1，并将 16 位哈希值输出至 hash 信号中。

// 以下代码应在实现时删去
assign finish = 1'b1;
assign hash = seed[31:16] ^ seed[15:0];
// 以上代码应在实现时删去

endmodule
