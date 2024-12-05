module tb_RNG16;  

    reg clk;                  // 时钟信号  
    reg rstn;                // 复位信号  
    reg update;              // 更新信号  
    wire finish;             // 完成信号  
    wire [15:0] rand16;      // 随机数输出  

    // 实例化 RNG16 模块  
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
        // 初始化信号  
        rstn = 0;   // 先置为低电平以复位  
        update = 0; // 更新信号初始为低  

        // 等待一些时间  
        #20;        
        rstn = 1;   // 取消复位  
        
        // 生成随机数  
        #10;  
        update = 1; // 设置更新信号以生成随机数  
        #10;  
        update = 0; // 清除更新信号  

        // 检查生成完成信号  
        wait(finish);  // 等待完成信号  
        #5;            // 等待一小段时间，确保输出稳定  
        $display("Generated Random Number: %h", rand16); // 打印生成的随机数  
        
        // 再次更新以生成新随机数  
        #10;  
        update = 1;  // 设置更新信号  
        #10;  
        update = 0;  // 清除更新信号  
        wait(finish); // 等待完成信号  
        #5;  
        $display("Generated Random Number: %h", rand16); // 打印新的随机数  

        // 结束测试  
        #30; // 等待一段时间  
        $finish; // 结束仿真  
    end  

endmodule