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
    input [31:0]        p1_bird_y,
    input [31:0] p1_bird_velocity,
    output [11:0] rgb
);

wire [11:0] col_outside = 12'h222;

wire [9:0] screen_x = pixel_x - 256;
wire [9:0] screen_y = pixel_y - 44;
wire [16:0] p1_bird_x_screen = 80;
wire [16:0] p1_bird_y_screen = 400 - p1_bird_y[31:16];
wire game_view = (pixel_x >= 256 && pixel_x <= 543 && pixel_y >= 44 && pixel_y <= 555);
wire in_bird = (screen_x >= 80 - 24) && (screen_x <= 80 + 24) && (screen_y >= p1_bird_y_screen - 24) && (screen_y <= p1_bird_y_screen + 24);

wire [16:0] addr_bg = ((screen_x >> 1) + 144 * (screen_y >> 1) + 144 * 256 * world_seed[15]) & {17{game_view}};
wire [11:0] col_bg;
BROM_Background_12x72k brom_bg (
  .clka(clk),       // input wire clka
  .addra(addr_bg),  // input wire [16 : 0] addra
  .douta(col_bg)    // output wire [11 : 0] douta
);

wire [6:0] x_in_bird = ((screen_x - p1_bird_x_screen + 24) >> 1);
wire [6:0] y_in_bird = ((screen_y - p1_bird_y_screen + 24) >> 1);
wire [12:0] addr_bird = (x_in_bird + 24 * y_in_bird) & {13{in_bird}};
wire [15:0] col_bird;
BROM_Bird_NoRotate_16x6k brom_bird (
  .clka(clk),         // input wire clka
  .addra(addr_bird),  // input wire [12 : 0] addra
  .douta(col_bird)    // output wire [15 : 0] douta
);
assign rgb = game_view ? (col_bird[3] ? col_bird[15:4] : col_bg) : col_outside;
endmodule