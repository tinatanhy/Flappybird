module PS_tb();

reg clk, rstn;
reg in;
initial begin
    clk = 0;
    in = 0;
    rstn = 0;
    #10;
    rstn = 1;
    forever #5 clk = ~clk;
end

initial begin
    #45;
    forever #200 in = ~in;
end

wire pclk, locked;

ClkWizPCLK clkwiz_pclk
(
    // Clock out ports
    .clk_out1(pclk),     // output clk_out1
    // Status and control signals
    .resetn(rstn), // input reset
    .locked(locked),       // output locked
    // Clock in ports
    .clk_in1(clk)      // input clk_in1
);

wire p;
PS #(1) ps(
    .s      (in),
    .rstn   (rstn),
    .clk    (pclk),
    .p      (p)
);

endmodule
