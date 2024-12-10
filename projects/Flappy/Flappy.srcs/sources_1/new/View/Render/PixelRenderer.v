module PixelRenderer(
    input clk,
    input pclk,
    input rstn,
    input [10:0] pixel_x,
    input [10:0] pixel_y,
    input [31:0] timer,
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
    input [31:0]         camera_x,
    input [31:0]        p1_bird_y,
    input [31:0] p1_bird_velocity,
    input [15:0]        bg_xshift,
    input [1:0]    bird_animation,
    input [7:0]     bird_rotation,
    output [11:0] rgb
);

wire [11:0] col_outside = 12'h222;

wire [9:0] screen_x = pixel_x - 256;
wire [9:0] screen_y = pixel_y - 44;
wire [31:0] game_x = camera_x + screen_x - 80;
wire [9:0]  game_y = 400 - screen_y;
wire screen_mask = (pixel_x >= 256 && pixel_x <= 543 && pixel_y >= 44 && pixel_y <= 555);

// Draw BG
wire [16:0] addr_bg = ((screen_x >>> 1) + 144 * (screen_y >>> 1) + 144 * 256 * world_seed[15]) & {17{screen_mask}};
wire [11:0] col_bg;
BROM_Background_12x72k brom_bg (
  .clka(clk),       // input wire clka
  .addra(addr_bg),  // input wire [16 : 0] addra
  .douta(col_bg)    // output wire [11 : 0] douta
);

// Draw Land
wire land_mask = game_y[9];
wire [4:0] land_x = ((game_x + 24 * 144) % 24) >>> 1;  // how to avoid %?
wire [4:0] land_y = ($unsigned((screen_y - 401) >>> 1) > $unsigned(11)) ? 11 : $unsigned((screen_y - 401) >>> 1);
wire [9:0] addr_land = ($unsigned(land_x) < 12 && $unsigned(land_y) < 12) ? (land_x + 12 * land_y) : 143;
wire [11:0] col_land;
BROM_Land_12x1k brom_land (
  .clka(clk),    // input wire clka
  .addra(addr_land),  // input wire [9 : 0] addra
  .douta(col_land)  // output wire [11 : 0] douta
);

// Draw Tubes
parameter TUBE_WIDTH = 52;
wire tube_mask_0_x = game_x > tube_pos0 && game_x <= (tube_pos0 + TUBE_WIDTH);
wire tube_mask_0_down = (game_y <= tube_height0) && tube_mask_0_x;
wire tube_mask_0_up = (game_y > (tube_height0 + tube_spacing0)) && tube_mask_0_x;
wire tube_mask_1_x = game_x > tube_pos1 && game_x <= (tube_pos1 + TUBE_WIDTH);
wire tube_mask_1_down = (game_y <= tube_height1) && tube_mask_1_x;
wire tube_mask_1_up = (game_y > (tube_height1 + tube_spacing1)) && tube_mask_1_x;
wire tube_mask_2_x = game_x > tube_pos2 && game_x <= (tube_pos2 + TUBE_WIDTH);
wire tube_mask_2_down = (game_y <= tube_height2) && tube_mask_2_x;
wire tube_mask_2_up = (game_y > (tube_height2 + tube_spacing2)) && tube_mask_2_x;
wire tube_mask_3_x = game_x > tube_pos3 && game_x <= (tube_pos3 + TUBE_WIDTH);
wire tube_mask_3_down = (game_y <= tube_height3) && tube_mask_3_x;
wire tube_mask_3_up = (game_y > (tube_height3 + tube_spacing3)) && tube_mask_3_x;
wire [9:0] tube_0_x = game_x - tube_pos0;
wire [9:0] tube_1_x = game_x - tube_pos1;
wire [9:0] tube_2_x = game_x - tube_pos2;
wire [9:0] tube_3_x = game_x - tube_pos3;
wire [9:0] tube_0_down_y = tube_height0 - game_y;
wire [9:0] tube_1_down_y = tube_height1 - game_y;
wire [9:0] tube_2_down_y = tube_height2 - game_y;
wire [9:0] tube_3_down_y = tube_height3 - game_y;
wire [9:0] tube_0_up_y = game_y - (tube_height0 + tube_spacing0 + 1);
wire [9:0] tube_1_up_y = game_y - (tube_height1 + tube_spacing1 + 1);
wire [9:0] tube_2_up_y = game_y - (tube_height2 + tube_spacing2 + 1);
wire [9:0] tube_3_up_y = game_y - (tube_height3 + tube_spacing3 + 1);
wire [9:0] tube_x = (({10{tube_mask_0_x}} & tube_0_x
                  |  {10{tube_mask_1_x}} & tube_1_x
                  |  {10{tube_mask_2_x}} & tube_2_x
                  |  {10{tube_mask_3_x}} & tube_3_x)) >>> 1;
wire [9:0] tube_y = ({10{tube_mask_0_down}} & tube_0_down_y
                  |  {10{tube_mask_1_down}} & tube_1_down_y
                  |  {10{tube_mask_2_down}} & tube_2_down_y
                  |  {10{tube_mask_3_down}} & tube_3_down_y
                  |  {10{tube_mask_0_up}} & tube_0_up_y
                  |  {10{tube_mask_1_up}} & tube_1_up_y
                  |  {10{tube_mask_2_up}} & tube_2_up_y
                  |  {10{tube_mask_3_up}} & tube_3_up_y) >>> 1;
wire [3:0] tube_img_y = (tube_y == 0) ? 0
                      : (tube_y == 1) ? 1
                      : (tube_y >= 2 && tube_y <= 9) ? 2
                      : (tube_y == 10) ? 3
                      : (tube_y == 11) ? 0
                      : (tube_y == 12) ? 5
                      : 6;
wire [9:0] addr_tube = tube_img_y * 26 + tube_x;
wire [15:0] col_tube_0;
wire [12:0] col_tube = col_tube_0[15:4];
wire tube_mask = col_tube_0[0] & (tube_mask_0_up || tube_mask_0_down || tube_mask_1_up || tube_mask_1_down || tube_mask_2_up || tube_mask_2_down || tube_mask_3_up || tube_mask_3_down);
BROM_Tube_16x1k brom_tube (
  .clka(clk),
  .addra(addr_tube),
  .douta(col_tube_0)
);

// Draw Bird
wire [1:0] bird_color = (&world_seed[14:13]) ? 2'b00 : world_seed[14:13];
wire [1:0] bird_anim =  (&bird_animation) ? 2'b01 : bird_animation;
wire [16:0] p1_bird_x_screen = 80 + bird_x - camera_x;
wire [16:0] p1_bird_y_screen = 400 - p1_bird_y[31:16];
wire [6:0] x_in_bird = ($signed(screen_x - p1_bird_x_screen + 24) >>> 1);
wire [6:0] y_in_bird = ($signed(screen_y - p1_bird_y_screen + 24) >>> 1);
wire bird_mask = (screen_x >= 80 - 24) && (screen_x <= 80 + 24) && ($signed(screen_y) >= $signed(p1_bird_y_screen - 24)) && ($signed(screen_y) <= $signed(p1_bird_y_screen + 24));
wire [12:0] addr_bird = (x_in_bird + 24 * y_in_bird + 24 * 24 * bird_anim + 24 * 24 * 3 * bird_color) & {13{bird_mask}};
wire [15:0] col_bird;
BROM_Bird_NoRotate_16x6k brom_bird (
  .clka(clk),         // input wire clka
  .addra(addr_bird),  // input wire [12 : 0] addra
  .douta(col_bird)    // output wire [15 : 0] douta
);

assign rgb = 
  (~screen_mask) ? col_outside :
  (bird_mask && col_bird[3]) ? col_bird[15:4] :
  (land_mask) ? col_land :
  (tube_mask) ? col_tube :
  col_bg;
endmodule