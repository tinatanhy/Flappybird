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
wire [16:0] addr_bg = ((screen_x >> 1) + 144 * (screen_y >> 1) + 144 * 256 * world_seed[15]) & {17{screen_mask}};
wire [11:0] col_bg;
BROM_Background_12x72k brom_bg (
  .clka(clk),       // input wire clka
  .addra(addr_bg),  // input wire [16 : 0] addra
  .douta(col_bg)    // output wire [11 : 0] douta
);

// Draw Land
wire land_mask = game_y[9];
wire [4:0] land_x = ((game_x + 24 * 144) % 24) >> 1;  // how to avoid %?
wire [4:0] land_y = $unsigned((screen_y - 401) >> 1) > $unsigned(11) ? 11 : $unsigned((screen_y - 401) >> 1);
wire [9:0] addr_land = land_x + land_y * 12;
wire [11:0] col_land;
BROM_Land_12x1k brom_land (
  .clka(clk),    // input wire clka
  .addra(addr_land),  // input wire [9 : 0] addra
  .douta(col_land)  // output wire [11 : 0] douta
);

// Draw Tubes
wire tube_mask = 1'b0;
wire [9:0] addr_tube = land_x + land_y * 12;
wire [11:0] col_tube;
BROM_Tube_16x1k brom_tube (
  .clka(clk),
  .addra(addr_tube),
  .douta(col_tube)
);

// Draw Bird
wire [1:0] bird_color = (&world_seed[14:13]) ? 2'b00 : world_seed[14:13];
wire [1:0] bird_anim =  (&bird_animation) ? 2'b01 : bird_animation;
wire [16:0] p1_bird_x_screen = 80 + bird_x - camera_x;
wire [16:0] p1_bird_y_screen = 400 - p1_bird_y[31:16];
wire [6:0] x_in_bird = ((screen_x - p1_bird_x_screen + 24) >> 1);
wire [6:0] y_in_bird = ((screen_y - p1_bird_y_screen + 24) >> 1);
wire bird_mask = (screen_x >= 80 - 24) && (screen_x <= 80 + 24) && (screen_y >= p1_bird_y_screen - 24) && (screen_y <= p1_bird_y_screen + 24);
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