module ScoreRenderer#(
    parameter LATENCY = 0
) (
    input  [15:0] screen_x, screen_y,
    input  [15:0] col_in,

    input [1:0] game_status,
    input [11:0] score_decimal,

    output [11:0] addr,
    output        mask,
    output [15:0] col_out
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
wire score_mask_x11 = game_status[1] && score_view_1 && ($signed(screen_x) >= $signed(score_x11)) && ($signed(screen_x - LATENCY) < $signed(score_x11 + 24));
wire score_mask_x21 = game_status[1] && score_view_2 && ($signed(screen_x) >= $signed(score_x21)) && ($signed(screen_x) < $signed(score_x21 + 24));
wire score_mask_x22 = game_status[1] && score_view_2 && ($signed(screen_x) >= $signed(score_x22)) && ($signed(screen_x - LATENCY) < $signed(score_x22 + 24));
wire score_mask_x31 = game_status[1] && score_view_3 && ($signed(screen_x) >= $signed(score_x31)) && ($signed(screen_x) < $signed(score_x31 + 24));
wire score_mask_x32 = game_status[1] && score_view_3 && ($signed(screen_x) >= $signed(score_x32)) && ($signed(screen_x) < $signed(score_x32 + 24));
wire score_mask_x33 = game_status[1] && score_view_3 && ($signed(screen_x) >= $signed(score_x33)) && ($signed(screen_x - LATENCY) < $signed(score_x33 + 24));
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
wire score_place_mask = score_mask_y & (score_mask_x11 || score_mask_x21 || score_mask_x22 || score_mask_x31 || score_mask_x32 || score_mask_x33);

assign addr = score_place_mask ? ({12{score_mask_y}} & (
	  {12{score_mask_x11}} & score_addr_11
	| {12{score_mask_x21}} & score_addr_21
	| {12{score_mask_x22}} & score_addr_22
	| {12{score_mask_x31}} & score_addr_31
	| {12{score_mask_x32}} & score_addr_32
	| {12{score_mask_x33}} & score_addr_33
)) : 12'd2161;
assign mask = score_place_mask & col_in[3];
assign col_out = col_in;
endmodule