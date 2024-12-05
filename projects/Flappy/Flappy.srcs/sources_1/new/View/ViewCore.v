module ViewCore#(
    parameter DW = 19,
    parameter H_LEN = 100,
    parameter V_LEN = 75,
    parameter N_TUBE = 4,
    parameter IND_TUBE_INTERACT = 1
)(
    input clk,
    input pclk,
    input rstn,
    output hs, vs,
    output [11:0] rgb
);

wire [10:0] pixel_x, pixel_y;
wire [DW-1:0] raddr;
wire [11:0] rgbimg, rgbuv, rdata;
wire hen, ven, pclk, locked;

reg [31:0] timer;

always @(posedge clk) begin
    if(rstn == 1'b0) begin
        timer <= 32'b0;
    end
    else begin
        timer <= timer + 1;
    end
end

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

assign rdata = (|rgbuv) ? rgbimg : 12'b0;

ClkWizPCLK clkwiz_pclk
(
    .clk_out1(pclk),
    .resetn(rstn),  
    .locked(locked),
    .clk_in1(clk)   
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
    .H_LEN(800),
    .V_LEN(600)
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
PixelRenderer pixelrenderer(
    .clk(clk),
    .rstn(rstn),
    .pixel_x(pixel_x),
    .pixel_y(pixel_y),
    .timer(timer),
    .rgb(rgbuv)
);
endmodule