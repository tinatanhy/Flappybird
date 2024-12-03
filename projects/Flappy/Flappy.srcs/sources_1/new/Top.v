module Top(
    input CLK100MHZ, CPU_RESETN,
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
endmodule
