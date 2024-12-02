module ViewCore#(
    parameter DW = 15,
    parameter H_LEN = 200,
    parameter V_LEN = 150
)(
    input clk,
    input rstn,
    output hs, vs,
    output [11:0] rgb
);

wire [DW-1:0] raddr;
wire [11:0] rdata;
wire hen, ven, pclk, locked;


BRAM_12x32k vram_canvas (
  .clka(clk),    
  .ena(1'b0),    
  .wea(1'b0),    
  .addra(15'b0), 
  .dina(12'b0),   
  .clkb(clk),   
  .enb(1'b1),     
  .addrb(raddr), 
  .doutb(rdata)  
);
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
DST dst(
    .rstn(rstn),
    .pclk(pclk),
    .hen(hen),
    .ven(ven),
    .hs(hs),
    .vs(vs)
);
DDP#(
    .DW(DW),
    .H_LEN(H_LEN),
    .V_LEN(V_LEN)
) ddp(
    .hen(hen),
    .ven(ven),
    .rstn(rstn),
    .pclk(pclk),
    .rdata(rdata),
    .rgb(rgb),
    .raddr(raddr)
);
endmodule