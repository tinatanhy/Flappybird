module PixelRenderer(
    input clk,
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
wire [9:0] screen_x = pixel_x - 256;
wire [9:0] screen_y = pixel_y - 44;
wire [16:0] p1_bird_y_screen = 400 - p1_bird_y[31:16];
wire game_view = (pixel_x >= 256 && pixel_x <= 543 && pixel_y >= 44 && pixel_y <= 555);
wire in_bird = (screen_x >= 80 - 12) && (screen_x <= 80 + 12) && (screen_y >= p1_bird_y_screen - 12) && (screen_y <= p1_bird_y_screen + 12);
assign rgb = game_view ? (in_bird ? 12'hF00 : 12'hFFF) : 12'h000;
endmodule