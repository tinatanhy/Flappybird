module Top(
    input CLK100MHZ, CPU_RESETN,BTNC,BTNU,BTNL,
    output VGA_HS, VGA_VS,
    output [3:0] VGA_R, VGA_G, VGA_B,
    output [2:0] LED
);
wire CLK72HZ;
ViewCore viewcore(
    .clk (CLK100MHZ),
    .rstn(CPU_RESETN),
    .hs  (VGA_HS),
    .vs  (VGA_VS),
    .rgb ({ VGA_R, VGA_G, VGA_B })
);
wire [2:0] led_w; // 声明一个 wire 来连接 LED 的输出  
time72hz time72hz(
    .pclk (CLK100MHZ),
    .rst(CPU_RESETN),
    .clk_out(CLK72HZ)
);
Button button_instance ( 
    .clk (CLK72HZ),  
    .BTNC (BTNC),   
    .LED (LED)   
); 

endmodule
