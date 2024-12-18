module PixelRenderer#(
    parameter LATENCY = 2
) (
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
        pixel_x <= pixel_x_in;
        pixel_y <= pixel_y_in;
    end
end

wire [16:0]  addr_bg;
wire [9:0]   addr_land;
wire [9:0]   addr_tube;
wire [15:0]  addr_bird;
wire [13:0]  addr_ui;
wire [11:0]  addr_score;

wire [11:0]  col_bg_in;
wire [11:0]  col_land0_in;
wire [15:0]  col_tube_0_in;
wire [15:0]  col_bird00_in;
wire [15:0]  col_bird01_in;
wire [15:0]  col_bird02_in;
wire [15:0]  col_ui_in;
wire [15:0]  col_score_in;

wire [11:0]  col_bg;
wire [11:0]  col_land;
wire [15:0]  col_tube;
wire [15:0]  col_bird;
wire [15:0]  col_ui;
wire [15:0]  col_score;

BROMAccess brom_access (
	.clk(clk),
	.pclk(pclk),
	.rstn(rstn),
	.addr_bg(addr_bg),
	.addr_land(addr_land),
	.addr_tube(addr_tube),
	.addr_bird(addr_bird),
	.addr_ui(addr_ui),
	.addr_score(addr_score),
	.col_bg(col_bg_in),
	.col_land0(col_land0_in),
	.col_tube_0(col_tube_0_in),
	.col_bird00(col_bird00_in),
	.col_bird01(col_bird01_in),
	.col_bird02(col_bird02_in),
	.col_ui(col_ui_in),
	.col_score(col_score_in)
);

// wire [11:0] col_outside = 12'h222;
wire [10:0] grid_x = pixel_x >> 5, grid_y = pixel_y >> 5;
wire [11:0] col_outside = (grid_x[0] ^ grid_y[0]) ? 12'h333 : 12'h222;

wire [15:0] screen_x = $signed(pixel_x + 2 - 256 + $signed({{8{shake_x[7]}}, shake_x}));
wire [15:0] screen_y = $signed(pixel_y - 44 +  $signed({{8{shake_y[7]}}, shake_y}));
wire [31:0] game_x = $signed(camera_x + {31'b0, screen_x} - 31'd80);
wire [31:0] game_y = 400 - screen_y;

wire screen_mask, land_mask, tube_mask, bird_mask, ui_mask, score_mask;

BGRenderer#(.LATENCY(LATENCY)) bg_renderer (
    .screen_x(screen_x),
    .screen_y(screen_y),
    .world_seed(world_seed),
    .col_in(col_bg_in),
    .addr(addr_bg),
    .mask(screen_mask),
    .col_out(col_bg)
);
LandRenderer#(.LATENCY(LATENCY)) land_renderer (
    .screen_x(screen_x),
    .screen_y(screen_y),
    .game_x(game_x),
    .game_y(game_y),
    .col_in(col_land0_in),
    .addr(addr_land),
    .mask(land_mask),
    .col_out(col_land)
);
TubeRenderer#(.LATENCY(LATENCY)) tube_renderer (
    .screen_x(screen_x),
    .screen_y(screen_y),
    .game_x(game_x),
    .game_y(game_y),
    .col_in(col_tube_0_in),
    .tube_pos0(tube_pos0),
    .tube_height0(tube_height0),
    .tube_spacing0(tube_spacing0),
    .tube_pos1(tube_pos1),
    .tube_height1(tube_height1),
    .tube_spacing1(tube_spacing1),
    .tube_pos2(tube_pos2),
    .tube_height2(tube_height2),
    .tube_spacing2(tube_spacing2),
    .tube_pos3(tube_pos3),
    .tube_height3(tube_height3),
    .tube_spacing3(tube_spacing3),
    .addr(addr_tube),
    .mask(tube_mask),
    .col_out(col_tube)
);
BirdRenderer#(.LATENCY(LATENCY)) bird_renderer(
    .screen_x(screen_x),
    .screen_y(screen_y),
    .world_seed(world_seed),
    .col_in_00(col_bird00_in),
    .col_in_01(col_bird01_in),
    .col_in_02(col_bird02_in),
    .bird_x(bird_x),
    .camera_x(camera_x),
    .p1_bird_y(p1_bird_y),
    .bird_animation(bird_animation),
    .bird_rotation(bird_rotation),
    .addr(addr_bird),
    .mask(bird_mask),
    .col_out(col_bird)
);
UIRenderer#(.LATENCY(LATENCY)) ui_renderer(
    .screen_x(screen_x),
    .screen_y(screen_y),
    .col_in(col_ui_in),
    .game_status(game_status),
    .timer(timer),
    .gameover_timestamp(gameover_timestamp),
    .addr(addr_ui),
    .mask(ui_mask),
    .col_out(col_ui)
);
ScoreRenderer#(.LATENCY(LATENCY)) score_renderer(
    .screen_x(screen_x),
    .screen_y(screen_y),
    .game_status(game_status),
    .score_decimal(score_decimal),
    .col_in(col_score_in),
    .addr(addr_score),
    .mask(score_mask),
    .col_out(col_score)
);

wire [11:0] rgb_layer0 = 
	(~screen_mask) ? col_outside :
	(score_mask) ? col_score[15:4] : 
	(land_mask) ? col_land :
	(tube_mask) ? col_tube[15:4] :
	col_bg;

wire [11:0] rgb_layer1 = col_bird[15:4];
wire [4:0] a_layer1 = ({1'b0, col_bird[3:0]} + |col_bird[3:0]) & {5{screen_mask}};

wire [7:0] r_blend_1 = rgb_layer0[11:8] * (8'b00010000 - a_layer1) + rgb_layer1[11:8] * a_layer1;
wire [7:0] g_blend_1 = rgb_layer0[7:4]  * (8'b00010000 - a_layer1) + rgb_layer1[7:4]  * a_layer1;
wire [7:0] b_blend_1 = rgb_layer0[3:0]  * (8'b00010000 - a_layer1) + rgb_layer1[3:0]  * a_layer1;

wire [11:0] rgb_layer2 = col_ui[15:4];
wire [4:0] a_layer2 = {1'b0, col_ui[3:0]} + |col_ui[3:0];

wire [7:0] r_blend_2 = r_blend_1[7:4]   * (8'b00010000 - a_layer2) + rgb_layer2[11:8] * a_layer2;
wire [7:0] g_blend_2 = g_blend_1[7:4]   * (8'b00010000 - a_layer2) + rgb_layer2[7:4]  * a_layer2;
wire [7:0] b_blend_2 = b_blend_1[7:4]   * (8'b00010000 - a_layer2) + rgb_layer2[3:0]  * a_layer2;

assign rgb = {r_blend_2[7:4], g_blend_2[7:4], b_blend_2[7:4]};
endmodule