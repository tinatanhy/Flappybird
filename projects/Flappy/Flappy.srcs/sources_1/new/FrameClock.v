module FrameClock(
    input wire clk,             // 输入的 100 MHz 时钟  
    input wire rstn,            // 复位信号  
    output clk_out              // 输出的 72 Hz 时钟  
);  

reg [20:0] counter;             // 计数器，21 位足够用来计算 1388888  
parameter DIVISOR = 1388888;    // 分频系数 - 100MHz/72Hz  

always @(posedge clk) begin  
    if (~rstn) begin  
        counter <= 0;  
    end else if (counter == DIVISOR - 1) begin  
        counter <= 0;           // 重置计数器  
    end else begin  
        counter <= counter + 1; 
    end  
end  

assign clk_out = (counter == 0);

endmodule  