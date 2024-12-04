module time72hz(
    input wire pclk,            // 输入的 100 MHz 时钟  
    input wire rstn,            // 复位信号  
    output reg clk_out          // 输出的 72 Hz 时钟  
);  

reg [20:0] counter;             // 计数器，21 位足够用来计算 1388888  
parameter DIVISOR = 1388888;    // 分频系数 - 100MHz/72Hz  

always @(posedge pclk) begin  
    if (~rstn) begin  
        counter <= 0;  
        clk_out <= 0;  
    end else if (counter == DIVISOR - 1) begin  
        counter <= 0;           // 重置计数器  
        clk_out <= ~clk_out;    // 翻转输出时钟  
    end else begin  
        counter <= counter + 1; 
    end  
end  

endmodule  