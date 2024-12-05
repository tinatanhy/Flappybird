module VGA_tb#(
    parameter DW = 19,
    parameter H_LEN = 100,
    parameter V_LEN = 75
)();

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

// wire pclk, locked;
// 
// ClkWizPCLK clkwiz_pclk
// (
//     // Clock out ports
//     .clk_out1(pclk),     // output clk_out1
//     // Status and control signals
//     .resetn(rstn_clk), // input reset
//     .locked(locked),       // output locked
//     // Clock in ports
//     .clk_in1(clk)      // input clk_in1
// );

wire VGA_HS, VGA_VS;
wire [2:0] LED;
wire [3:0] VGA_R, VGA_G, VGA_B;
ViewCore#(
    .N_TUBE(4),
    .IND_TUBE_INTERACT(1)
) viewcore(
    .clk (clk),
    .rstn(rstn),
    .hs  (VGA_HS),
    .vs  (VGA_VS),
    .rgb ({ VGA_R, VGA_G, VGA_B })
);

endmodule
