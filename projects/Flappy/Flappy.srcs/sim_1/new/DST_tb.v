module DST_tb();

reg clk, rstn, rstn_clk;
initial begin
    clk = 0;
    rstn = 0;
    rstn_clk = 0;
    #10;
    rstn_clk = 1;
    forever #5 clk = ~clk;
end

initial begin
    #100000;
    rstn = 1;
end

wire pclk, locked;

ClkWizPCLK clkwiz_pclk
(
    // Clock out ports
    .clk_out1(pclk),     // output clk_out1
    // Status and control signals
    .resetn(rstn_clk), // input reset
    .locked(locked),       // output locked
    // Clock in ports
    .clk_in1(clk)      // input clk_in1
);

wire hen, ven, hs, vs;
DST dst (
    .rstn(rstn),
    .pclk(pclk),

    .hen(hen),        //水平显示有效
    .ven(ven),        //垂直显示有效
    .hs(hs),         //行同步
    .vs(vs)          //场同步
);
endmodule
