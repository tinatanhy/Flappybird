module Top(
    input CLK100MHZ, CPU_RESETN,BTNC,BTNU,BTNL,
    output VGA_HS, VGA_VS,
    output [3:0] VGA_R, VGA_G, VGA_B,
    output [2:0] LED
);
ViewCore viewcore(
    .clk (CLK100MHZ),
    .rstn(CPU_RESETN),
    .hs  (VGA_HS),
    .vs  (VGA_VS),
    .rgb ({ VGA_R, VGA_G, VGA_B })
);
wire [2:0] led_w; // 声明一个 wire 来连接 LED 的输出  

Button button_instance ( 
    .clk (CLK100MHZ),  
    .BTNC (BTNC),  
    .BTNU (BTNU),  
    .BTNL (BTNL),  
    .LED (LED)   
); 

endmodule
