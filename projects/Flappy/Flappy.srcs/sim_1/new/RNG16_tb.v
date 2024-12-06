

module tb_RNG16;  
    reg clk;  
    reg rstn;  
    reg update;  
    wire finish;  
    wire [15:0] rand16;  

    // 实例�? RNG16 模块  
    RNG16 uut (  
        .clk(clk),  
        .rstn(rstn),  
        .update(update),  
        .finish(finish),  
        .rand16(rand16)  
    );  

    // 生成时钟信号  
    initial begin  
        clk = 0;  
        forever #5 clk = ~clk; // 100MHz 时钟  
    end  

    // 测试逻辑  
    initial begin  
        rstn = 0;   // 复位  
        update = 0; // 初始为低  
        #10;  
        rstn = 1;   // 取消复位  
        #10;  
        update = 1; // 触发更新  
        #10;  
        update = 0; // 清除更新信号  


        
        // 生成新随机数  
        #10;  
        update = 1; // 再次触发更新  
        #10;  
        update = 0; // 清除更新信号  
        // 结束仿真  
        #30;  
        $finish;  
    end  
endmodule