module ViewCore#(
    parameter DW = 19,
    parameter H_LEN = 100,
    parameter V_LEN = 75,
    parameter N_TUBE = 4,
    parameter IND_TUBE_INTERACT = 1
)(
    input clk,
    input rstn,
    output hs, vs,
    output [11:0] rgb
);

wire [10:0] pixel_x, pixel_y;
wire [DW-1:0] raddr;
wire [11:0] rgbimg, rgbuv, rdata;
wire hen, ven, pclk, locked;


BRAM_Anim vram_canvas (
  .clka(clk),    
  .ena(1'b0),    
  .wea(1'b0),    
  .addra({DW{1'b0}}), 
  .dina(12'b0),   
  .clkb(clk),   
  .enb(1'b1),     
  .addrb(raddr), 
  .doutb(rgbimg)  
);
PixelRenderer pixelrenderer(
    .clk(clk),
    .rstn(rstn),
    .pixel_x(pixel_x),
    .pixel_y(pixel_y),
    .rgb(rgbuv)
);
wire [23:0] rgbmultiply = rgbimg * rgbuv;
assign rdata = rgbmultiply[23:12];
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
DDPGame#(
    .H_LEN(H_LEN),
    .V_LEN(V_LEN)
) ddp(
    .hen(hen),
    .ven(ven),
    .rstn(rstn),
    .pclk(pclk),
    .rdata(rdata),
    .rgb(rgb),
    .pixel_x(pixel_x),
    .pixel_y(pixel_y)
);
AnimFrameCounter#(
    .DW(DW),
    .FRAME_SIZE(7500),
    .FRAME_N(40)
) framecounter (
    .pclk(pclk), 
    .rstn(rstn), 
    .ven(ven),
    .imgaddr((pixel_y >> 3) * 100 + (pixel_x >> 3)),
    .raddr(raddr)
);
endmodule