module SegWithMaskTop(  
    input                   CLK100MHZ,     // 100MHz 时钟信号  
    input                   BTNC,          // 复位按钮  
    output  [7:0]       AN,            // 8位输出，控制8个数码管的阳极  
    output  [6:0]       seg_data,      // 7段显示器数据输出   
);  
    wire [7:0] output_valid;  // 输出有效信号  

    
    // 假设所有输出都是有效的  
    assign output_valid = 8'b11111111;   
    
    SegWithMask SegWithMaskInst(  
        .clk(CLK100MHZ),  
        .rst(BTNC),  
        .output_data(32'h45678ABC),    
        .output_valid(output_valid),  
        .seg_data(seg_data),  
        .seg_an(AN)  
    );  
endmodule