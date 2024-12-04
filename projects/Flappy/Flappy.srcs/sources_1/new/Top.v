module Top(
    input CLK100MHZ, CPU_RESETN, BTNC,
    output VGA_HS, VGA_VS,
    output [3:0] VGA_R, VGA_G, VGA_B
);

ViewCore viewcore(
    .clk (CLK100MHZ),
    .rstn(CPU_RESETN),
    .hs  (VGA_HS),
    .vs  (VGA_VS),
    .rgb ({ VGA_R, VGA_G, VGA_B })
);

wire CLK72HZ;
time72hz time72hz(
    .pclk (CLK100MHZ),
    .rstn (CPU_RESETN),
    .clk_out(CLK72HZ)
);

wire pressed;         
wire check;         
wire released;        

Button button_inst (  
    .clk(CLK72HZ),  
    .btn(BTNC),  
    .pressed(pressed),  
    .check(check),  
    .released(released)  
);  

assign LED[0] = check;  
assign LED[1] = released;  
assign LED[2] = pressed;  

endmodule
