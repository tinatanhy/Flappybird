module PixelRenderer(
    input clk,
    input pclk,
    input rstn,
    input [10:0] pixel_x_in,
    input [10:0] pixel_y_in,
    input [31:0] timer,
    input [31:0] gameover_timestamp,
    input [15:0]       world_seed,
    input [1:0]       game_status,
    input [15:0]            score,
    input [11:0]    score_decimal,
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
    input [7:0]      shake_x,
    input [7:0]      shake_y,
    output [11:0] rgb
);

reg[10:0] pixel_x, pixel_y;
always @(posedge pclk) begin
    if(~rstn) begin
        pixel_x <= 0;
        pixel_y <= 0;
    end else begin
        pixel_x <= pixel_x_in - 2;
        pixel_y <= pixel_y_in;
    end
end

// wire [11:0] col_outside = 12'h222;
wire [10:0] grid_x = pixel_x >> 4, grid_y = pixel_y >> 4;
wire [11:0] col_outside = (grid_x[0] ^ grid_y[0]) ? 12'h333 : 12'h222;

wire [15:0] screen_x = $signed(pixel_x - 256 + shake_x);
wire [15:0] screen_y = $signed(pixel_y - 44 + shake_y);
wire [15:0] game_x = camera_x + screen_x - 80;
wire [15:0] game_y = 400 - screen_y;
wire screen_mask = ($signed(screen_x) >= $signed(0) && $signed(screen_y) >= $signed(0) && $signed(screen_x) < $signed(288) && $signed(screen_y) < $signed(512));

// Draw BG
wire [16:0] addr_bg = (((screen_x - 1) >> 1) + 144 * (screen_y >> 1) + 144 * 256 * world_seed[15]) & {17{screen_mask}};
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
wire [9:0] addr_land = land_mask ? (($unsigned(land_x) < 12 && $unsigned(land_y) < 12) ? (land_x + 12 * land_y) : 143) : 256;
wire [11:0] col_land;
BROM_Land_12x1k brom_land (
  .clka(clk),    // input wire clka
  .addra(addr_land),  // input wire [9 : 0] addra
  .douta(col_land)  // output wire [11 : 0] douta
);

// Draw Tubes
parameter TUBE_WIDTH = 52;
wire [15:0] tube_0_x = game_x - tube_pos0;
wire [15:0] tube_1_x = game_x - tube_pos1;
wire [15:0] tube_2_x = game_x - tube_pos2;
wire [15:0] tube_3_x = game_x - tube_pos3;
wire tube_mask_0_x =    $signed(tube_0_x) >= 0 && $signed(game_x) >= $signed(tube_pos0) && $signed(game_x) < $signed(tube_pos0 + TUBE_WIDTH);
wire tube_mask_1_x =    $signed(tube_1_x) >= 0 && $signed(game_x) >= $signed(tube_pos1) && $signed(game_x) < $signed(tube_pos1 + TUBE_WIDTH);
wire tube_mask_2_x =    $signed(tube_2_x) >= 0 && $signed(game_x) >= $signed(tube_pos2) && $signed(game_x) < $signed(tube_pos2 + TUBE_WIDTH);
wire tube_mask_3_x =    $signed(tube_3_x) >= 0 && $signed(game_x) >= $signed(tube_pos3) && $signed(game_x) < $signed(tube_pos3 + TUBE_WIDTH);
wire tube_mask_0_down = ($signed(game_y) <= $signed(tube_height0)) && tube_mask_0_x;
wire tube_mask_1_down = ($signed(game_y) <= $signed(tube_height1)) && tube_mask_1_x;
wire tube_mask_2_down = ($signed(game_y) <= $signed(tube_height2)) && tube_mask_2_x;
wire tube_mask_3_down = ($signed(game_y) <= $signed(tube_height3)) && tube_mask_3_x;
wire tube_mask_0_up =   ($signed(game_y) >  $signed(tube_height0 + tube_spacing0)) && tube_mask_0_x;
wire tube_mask_1_up =   ($signed(game_y) >  $signed(tube_height1 + tube_spacing1)) && tube_mask_1_x;
wire tube_mask_2_up =   ($signed(game_y) >  $signed(tube_height2 + tube_spacing2)) && tube_mask_2_x;
wire tube_mask_3_up =   ($signed(game_y) >  $signed(tube_height3 + tube_spacing3)) && tube_mask_3_x;
wire [15:0] tube_0_down_y = tube_height0 - game_y;
wire [15:0] tube_1_down_y = tube_height1 - game_y;
wire [15:0] tube_2_down_y = tube_height2 - game_y;
wire [15:0] tube_3_down_y = tube_height3 - game_y;
wire [15:0] tube_0_up_y = game_y - (tube_height0 + tube_spacing0 + 1);
wire [15:0] tube_1_up_y = game_y - (tube_height1 + tube_spacing1 + 1);
wire [15:0] tube_2_up_y = game_y - (tube_height2 + tube_spacing2 + 1);
wire [15:0] tube_3_up_y = game_y - (tube_height3 + tube_spacing3 + 1);
wire [9:0] tube_x = (({10{tube_mask_0_x}} & tube_0_x[9:0]
                  |   {10{tube_mask_1_x}} & tube_1_x[9:0]
                  |   {10{tube_mask_2_x}} & tube_2_x[9:0]
                  |   {10{tube_mask_3_x}} & tube_3_x[9:0])) >> 1;
wire [9:0] tube_y = ({10{tube_mask_0_down}} & tube_0_down_y[9:0]
                  |  {10{tube_mask_1_down}} & tube_1_down_y[9:0]
                  |  {10{tube_mask_2_down}} & tube_2_down_y[9:0]
                  |  {10{tube_mask_3_down}} & tube_3_down_y[9:0]
                  |  {10{tube_mask_0_up}}   &   tube_0_up_y[9:0]
                  |  {10{tube_mask_1_up}}   &   tube_1_up_y[9:0]
                  |  {10{tube_mask_2_up}}   &   tube_2_up_y[9:0]
                  |  {10{tube_mask_3_up}}   &   tube_3_up_y[9:0]) >> 1;
wire [3:0] tube_img_y = ($signed(tube_y) == 0) ? 0
                      : ($signed(tube_y) == 1) ? 1
                      : ($signed(tube_y) >= 2 && $signed(tube_y) <= 9) ? 2
                      : ($signed(tube_y) == 10) ? 3
                      : ($signed(tube_y) == 11) ? 0
                      : ($signed(tube_y) == 12) ? 5
                      : 6;
wire tube_place_mask = (tube_mask_0_up || tube_mask_0_down || tube_mask_1_up || tube_mask_1_down || tube_mask_2_up || tube_mask_2_down || tube_mask_3_up || tube_mask_3_down);
wire [9:0] addr_tube = tube_place_mask ? (tube_img_y * 26 + tube_x) : 10'd256;
wire [15:0] col_tube_0;
wire [12:0] col_tube = col_tube_0[15:4];
wire tube_mask = col_tube_0[3] & tube_place_mask;
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

// Draw UI
localparam text_center_x = 144, text_center_y = 160;
localparam tuto_center_x = 144, tuto_center_y = 256;
localparam tuto_w = 57, tuto_h = 49;
localparam gameover_w = 96, gameover_h = 21;
localparam ready_w = 92, ready_h = 25;
localparam tuto_x0 = tuto_center_x - tuto_w, tuto_x1 = tuto_center_x + tuto_w - 1, tuto_y0 = tuto_center_y - tuto_h, tuto_y1 = tuto_center_y + tuto_h - 1;
localparam gameover_x0 = text_center_x - gameover_w, gameover_x1 = text_center_x + gameover_w - 1, gameover_y0 = text_center_y - gameover_h, gameover_y1 = text_center_y + gameover_h - 1;
localparam ready_x0 = text_center_x - ready_w, ready_x1 = text_center_x + ready_w - 1, ready_y0 = text_center_y - ready_h, ready_y1 = text_center_y + ready_h - 1;
wire tuto_mask =     (game_status == 2'b01) & (($signed(screen_x) >= tuto_x0) &&     ($signed(screen_x) <= tuto_x1) &&     ($signed(screen_y) >= tuto_y0) &&     ($signed(screen_y) <= tuto_y1));
wire ready_mask =    (game_status == 2'b01) & (($signed(screen_x) >= ready_x0) &&    ($signed(screen_x) <= ready_x1) &&    ($signed(screen_y) >= ready_y0) &&    ($signed(screen_y) <= ready_y1));
wire gameover_mask = (game_status == 2'b11) & (($signed(screen_x) >= gameover_x0) && ($signed(screen_x) <= gameover_x1) && ($signed(screen_y) >= gameover_y0) && ($signed(screen_y) <= gameover_y1));
wire [12:0] tuto_x = (screen_x - tuto_x0) >> 1, tuto_y = (screen_y - tuto_y0) >> 1;
wire [12:0] gameover_x = (screen_x - gameover_x0) >> 1, gameover_y = (screen_y - gameover_y0) >> 1;
wire [12:0] ready_x = (screen_x - ready_x0) >> 1, ready_y = (screen_y - ready_y0) >> 1;
wire [12:0] tuto_addr =     tuto_x + tuto_w * tuto_y;
wire [12:0] gameover_addr = 13'd2793 + gameover_x + gameover_w * gameover_y;
wire [12:0] ready_addr =    13'd4809 + ready_x + ready_w * ready_y;
wire [12:0] addr_ui = tuto_addr & {13{tuto_mask}} 
                    | gameover_addr & {13{gameover_mask}} 
                    | ready_addr & {13{ready_mask}};
wire [15:0] col_ui;
wire [11:0] rgb_ui = col_ui[15:4];
wire [31:0] gameover_delta_time = timer - gameover_timestamp;
wire [31:0] alpha_time = $signed(gameover_delta_time) < 0 ? 0 :
                         $signed(gameover_delta_time) > 31 ? 31 : 
                         $signed(gameover_delta_time);

wire ui_mask = (tuto_mask | gameover_mask | ready_mask) & col_ui[3];
wire [3:0] alpha_ui = ui_mask ? ((game_status == 2'b11) ? (alpha_time[4:1] & col_ui[3:0]) : col_ui[3:0]) : 4'b0;
BROM_CompTexture_16x7k brom_comptex (
    .clka(clk),    // input wire clka
    .addra(addr_ui),  // input wire [12 : 0] addra
    .douta(col_ui)  // output wire [15 : 0] douta
);
localparam num_w = 12, num_h = 18, img_w = 120,
		   score_y = 54, 
           score_x11 = 144 - 12,
		   score_x21 = 144 - 24,
		   score_x22 = 144 - 0,
		   score_x31 = 144 - 12 - 24,
		   score_x32 = 144 - 12,
		   score_x33 = 144 - 12 + 24;
wire score_view_1 = ~(|score_decimal[11:8]) & ~(|score_decimal[7:4]),
     score_view_2 = ~(|score_decimal[11:8]) & (|score_decimal[7:4]),
     score_view_3 = (|score_decimal[11:8]);
wire score_mask_y = ($signed(screen_y) >= score_y) && ($signed(screen_y) < score_y + 36);
wire score_mask_x11 = game_status != 2'b01 && score_view_1 && ($signed(screen_x) >= $signed(score_x11)) && ($signed(screen_x) < $signed(score_x11 + 24));
wire score_mask_x21 = game_status != 2'b01 && score_view_2 && ($signed(screen_x) >= $signed(score_x21)) && ($signed(screen_x) < $signed(score_x21 + 24));
wire score_mask_x22 = game_status != 2'b01 && score_view_2 && ($signed(screen_x) >= $signed(score_x22)) && ($signed(screen_x) < $signed(score_x22 + 24));
wire score_mask_x31 = game_status != 2'b01 && score_view_3 && ($signed(screen_x) >= $signed(score_x31)) && ($signed(screen_x) < $signed(score_x31 + 24));
wire score_mask_x32 = game_status != 2'b01 && score_view_3 && ($signed(screen_x) >= $signed(score_x32)) && ($signed(screen_x) < $signed(score_x32 + 24));
wire score_mask_x33 = game_status != 2'b01 && score_view_3 && ($signed(screen_x) >= $signed(score_x33)) && ($signed(screen_x) < $signed(score_x33 + 24));
wire [11:0] score_posx_11 = (screen_x - score_x11) >> 1;
wire [11:0] score_posx_21 = (screen_x - score_x21) >> 1;
wire [11:0] score_posx_22 = (screen_x - score_x22) >> 1;
wire [11:0] score_posx_31 = (screen_x - score_x31) >> 1;
wire [11:0] score_posx_32 = (screen_x - score_x32) >> 1;
wire [11:0] score_posx_33 = (screen_x - score_x33) >> 1;
wire [11:0] score_posy    = (screen_y - score_y) >> 1;
wire [11:0] score_addr_11 = score_posx_11 + img_w * score_posy + score_decimal[3:0] * num_w;
wire [11:0] score_addr_21 = score_posx_21 + img_w * score_posy + score_decimal[7:4] * num_w;
wire [11:0] score_addr_22 = score_posx_22 + img_w * score_posy + score_decimal[3:0] * num_w;
wire [11:0] score_addr_31 = score_posx_31 + img_w * score_posy + score_decimal[11:8] * num_w;
wire [11:0] score_addr_32 = score_posx_32 + img_w * score_posy + score_decimal[7:4] * num_w;
wire [11:0] score_addr_33 = score_posx_33 + img_w * score_posy + score_decimal[3:0] * num_w;
wire [15:0] col_score;
wire score_place_mask = score_mask_y & (score_mask_x11 || score_mask_x21 || score_mask_x22 || score_mask_x31 || score_mask_x32 || score_mask_x33);
wire [11:0] addr_score = score_place_mask ? ({12{score_mask_y}} & (
	{12{score_mask_x11}} & score_addr_11
  | {12{score_mask_x21}} & score_addr_21
  | {12{score_mask_x22}} & score_addr_22
  | {12{score_mask_x31}} & score_addr_31
  | {12{score_mask_x32}} & score_addr_32
  | {12{score_mask_x33}} & score_addr_33
)) : 12'd2161;
wire score_mask = score_place_mask & col_score[3];
BROM_Numbers_16x3k brom_score (
    .clka(clk),    // input wire clka
    .addra(addr_score),  // input wire [11 : 0] addra
    .douta(col_score)  // output wire [15 : 0] douta
);
wire [11:0] rgb_layer0 = 
  (~screen_mask) ? col_outside :
  (score_mask) ? col_score[15:4] : 
  (bird_mask && col_bird[3]) ? col_bird[15:4] :
  (land_mask) ? col_land :
  (tube_mask) ? col_tube :
  col_bg;
wire [11:0] rgb_layer1 = rgb_ui;
wire [3:0] a_layer1 = alpha_ui;
wire [11:0] rgb_layer2 = 12'h000;
wire [3:0] a_layer2 = 4'b0000;

wire [7:0] r_blend_1 = rgb_layer0[11:8] * (8'b00010000 - a_layer1) + rgb_layer1[11:8] * a_layer1;
wire [7:0] g_blend_1 = rgb_layer0[7:4] * (8'b00010000 - a_layer1) + rgb_layer1[7:4] * a_layer1;
wire [7:0] b_blend_1 = rgb_layer0[3:0] * (8'b00010000 - a_layer1) + rgb_layer1[3:0] * a_layer1;
wire [7:0] r_blend_2 = r_blend_1[7:4] * (8'b00010000 - a_layer2) + rgb_layer2[11:8] * a_layer2;
wire [7:0] g_blend_2 = g_blend_1[7:4] * (8'b00010000 - a_layer2) + rgb_layer2[7:4] * a_layer2;
wire [7:0] b_blend_2 = b_blend_1[7:4] * (8'b00010000 - a_layer2) + rgb_layer2[3:0] * a_layer2;
assign rgb = {r_blend_2[7:4], g_blend_2[7:4], b_blend_2[7:4]};
endmodule