module TubeRenderer#(
    parameter LATENCY = 0
) (
    input  [15:0] screen_x, screen_y,
    input  [31:0] game_x, game_y,
    input  [15:0] col_in,

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

    output [ 9:0] addr,
    output        mask,
    output [15:0] col_out
);

localparam  TUBE_WIDTH = 52;
wire [31:0] tube_0_x = game_x - tube_pos0;
wire [31:0] tube_1_x = game_x - tube_pos1;
wire [31:0] tube_2_x = game_x - tube_pos2;
wire tube_mask_0_x =    $signed(game_x) >= $signed(tube_pos0) && $signed(game_x - LATENCY) < $signed(tube_pos0 + TUBE_WIDTH + 1);
wire tube_mask_1_x =    $signed(game_x) >= $signed(tube_pos1) && $signed(game_x - LATENCY) < $signed(tube_pos1 + TUBE_WIDTH + 1);
wire tube_mask_2_x =    $signed(game_x) >= $signed(tube_pos2) && $signed(game_x - LATENCY) < $signed(tube_pos2 + TUBE_WIDTH + 1);
wire tube_mask_0_down = ($signed(game_y) <= $signed(tube_height0)) && tube_mask_0_x;
wire tube_mask_1_down = ($signed(game_y) <= $signed(tube_height1)) && tube_mask_1_x;
wire tube_mask_2_down = ($signed(game_y) <= $signed(tube_height2)) && tube_mask_2_x;
wire tube_mask_0_up =   ($signed(game_y) >  $signed(tube_height0 + tube_spacing0)) && tube_mask_0_x;
wire tube_mask_1_up =   ($signed(game_y) >  $signed(tube_height1 + tube_spacing1)) && tube_mask_1_x;
wire tube_mask_2_up =   ($signed(game_y) >  $signed(tube_height2 + tube_spacing2)) && tube_mask_2_x;
wire [15:0] tube_0_down_y = tube_height0 - game_y;
wire [15:0] tube_1_down_y = tube_height1 - game_y;
wire [15:0] tube_2_down_y = tube_height2 - game_y;
wire [15:0] tube_0_up_y = game_y - (tube_height0 + tube_spacing0 + 1);
wire [15:0] tube_1_up_y = game_y - (tube_height1 + tube_spacing1 + 1);
wire [15:0] tube_2_up_y = game_y - (tube_height2 + tube_spacing2 + 1);
wire [9:0] tube_x = (({10{tube_mask_0_x}} & tube_0_x[9:0]
                  |   {10{tube_mask_1_x}} & tube_1_x[9:0]
                  |   {10{tube_mask_2_x}} & tube_2_x[9:0])) >> 1;
wire [9:0] tube_y = ({10{tube_mask_0_down}} & tube_0_down_y[9:0]
                  |  {10{tube_mask_1_down}} & tube_1_down_y[9:0]
                  |  {10{tube_mask_2_down}} & tube_2_down_y[9:0]
                  |  {10{tube_mask_0_up}}   &   tube_0_up_y[9:0]
                  |  {10{tube_mask_1_up}}   &   tube_1_up_y[9:0]
                  |  {10{tube_mask_2_up}}   &   tube_2_up_y[9:0]) >> 1;
wire [3:0] tube_img_y = {3{($signed(tube_y) == 0)}} & 4'd0
                      | {3{($signed(tube_y) == 1)}} & 4'd1
                      | {3{($signed(tube_y) >= 2 && $signed(tube_y) <= 9)}} & 4'd2
                      | {3{($signed(tube_y) == 10)}} & 4'd3
                      | {3{($signed(tube_y) == 11)}} & 4'd0
                      | {3{($signed(tube_y) == 12)}} & 4'd5
                      | {3{(tube_y > 12)}} & 4'd6;
wire tube_place_mask = (tube_mask_0_up || tube_mask_0_down || tube_mask_1_up || tube_mask_1_down || tube_mask_2_up || tube_mask_2_down);

assign addr = tube_place_mask ? (tube_img_y * 26 + tube_x) : 10'd256;
assign col_out = col_in;
assign mask = col_in[3] & tube_place_mask;
endmodule