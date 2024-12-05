module ViewCore#(
    parameter DW = 19,
    parameter H_LEN = 100,
    parameter V_LEN = 75,
    parameter N_TUBE = 4,
    parameter IND_TUBE_INTERACT = 1
)(
    input clk,
    input rstn,
    input upd,
    input [15:0]       world_seed,
    input [1:0]       game_status,
    input [15:0]            score,
    input [31:0]        tube_pos0,
    input [15:0]     tube_height0,
    input [7:0]     tube_spacing0,
    input [31:0]        tube_pos1,
    input [15:0]     tube_height1,
    input [7:0]     tube_spacing1,
    input [31:0]        tube_pos2,
    input [15:0]     tube_height2,
    input [7:0]     tube_spacing2,
    input [31:0]        tube_pos3,
    input [15:0]     tube_height3,
    input [7:0]     tube_spacing3,
    input [31:0]           bird_x,
    input [31:0]        p1_bird_y,
    input [31:0] p1_bird_velocity,
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

// BRAM_Anim vram_canvas (
//   .clka(clk),    
//   .ena(1'b0),    
//   .wea(1'b0),    
//   .addra({DW{1'b0}}), 
//   .dina(12'b0),   
//   .clkb(clk),   
//   .enb(1'b1),     
//   .addrb(raddr), 
//   .doutb(rgbimg)  
// );

// assign rdata = (|rgbuv) ? rgbimg : 12'b0;
assign rdata = rgbuv;

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
    .world_seed       (world_seed),
    .game_status      (game_status),
    .score            (score),
    .tube_pos0        (tube_pos0),
    .tube_height0     (tube_height0),
    .tube_spacing0    (tube_spacing0),
    .tube_pos1        (tube_pos1),
    .tube_height1     (tube_height1),
    .tube_spacing1    (tube_spacing1),
    .tube_pos2        (tube_pos2),
    .tube_height2     (tube_height2),
    .tube_spacing2    (tube_spacing2),
    .tube_pos3        (tube_pos3),
    .tube_height3     (tube_height3),
    .tube_spacing3    (tube_spacing3),
    .bird_x           (bird_x),
    .p1_bird_y        (p1_bird_y),
    .p1_bird_velocity (p1_bird_velocity),
    .timer(timer),
    .rgb(rgbuv)
);
endmodule