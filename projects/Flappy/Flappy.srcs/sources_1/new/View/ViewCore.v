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
    input [31:0]            timer_in,
    input [15:0]       world_seed_in,
    input [1:0]       game_status_in,
    input [15:0]            score_in,
    input [31:0]        tube_pos0_in,
    input [15:0]     tube_height0_in,
    input [7:0]     tube_spacing0_in,
    input [31:0]        tube_pos1_in,
    input [15:0]     tube_height1_in,
    input [7:0]     tube_spacing1_in,
    input [31:0]        tube_pos2_in,
    input [15:0]     tube_height2_in,
    input [7:0]     tube_spacing2_in,
    input [31:0]        tube_pos3_in,
    input [15:0]     tube_height3_in,
    input [7:0]     tube_spacing3_in,
    input [31:0]           bird_x_in,
    input [31:0]         camera_x_in,
    input [31:0]        p1_bird_y_in,
    input [31:0] p1_bird_velocity_in,
    input [15:0]        bg_xshift_in,
    input [1:0]    bird_animation_in,
    input [7:0]     bird_rotation_in,
    output [15:0] view_debug_led,
    output [31:0] view_debug_seg,
    output hs, vs,
    output [11:0] rgb
);

// Buffering
reg [31:0]            timer;
reg [15:0]       world_seed;
reg [1:0]       game_status;
reg [15:0]            score;
reg [31:0]        tube_pos0;
reg [15:0]     tube_height0;
reg [7:0]     tube_spacing0;
reg [31:0]        tube_pos1;
reg [15:0]     tube_height1;
reg [7:0]     tube_spacing1;
reg [31:0]        tube_pos2;
reg [15:0]     tube_height2;
reg [7:0]     tube_spacing2;
reg [31:0]        tube_pos3;
reg [15:0]     tube_height3;
reg [7:0]     tube_spacing3;
reg [31:0]           bird_x;
reg [31:0]         camera_x;
reg [31:0]        p1_bird_y;
reg [31:0] p1_bird_velocity;
reg [15:0]        bg_xshift;
reg [1:0]    bird_animation;
reg [7:0]     bird_rotation;

wire [10:0] pixel_x, pixel_y;
wire [DW-1:0] raddr;
wire [11:0] rdata;
wire hen, ven, pclk, locked;

always @(*) begin
    if(pixel_x == 0 && pixel_y == 0) begin
        timer = timer_in;
        world_seed = world_seed_in;
        game_status = game_status_in;
        score = score_in;
        tube_pos0 = tube_pos0_in;
        tube_height0 = tube_height0_in;
        tube_spacing0 = tube_spacing0_in;
        tube_pos1 = tube_pos1_in;
        tube_height1 = tube_height1_in;
        tube_spacing1 = tube_spacing1_in;
        tube_pos2 = tube_pos2_in;
        tube_height2 = tube_height2_in;
        tube_spacing2 = tube_spacing2_in;
        tube_pos3 = tube_pos3_in;
        tube_height3 = tube_height3_in;
        tube_spacing3 = tube_spacing3_in;
        bird_x = bird_x_in;
        camera_x = camera_x_in;
        p1_bird_y = p1_bird_y_in;
        p1_bird_velocity = p1_bird_velocity_in;
        bg_xshift = bg_xshift_in;
        bird_animation = bird_animation_in;
        bird_rotation = bird_rotation_in;
    end
end

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
    .pclk(pclk),
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
    .camera_x         (camera_x),
    .p1_bird_y        (p1_bird_y),
    .p1_bird_velocity (p1_bird_velocity),
    .bg_xshift        (bg_xshift),
    .bird_animation   (bird_animation),
    .bird_rotation    (bird_rotation),
    .timer(timer),
    .rgb(rdata)
);
assign view_debug_led = 32'h0;
assign view_debug_seg[31:16] = pixel_x;
assign view_debug_seg[15:0] = pixel_y;
endmodule