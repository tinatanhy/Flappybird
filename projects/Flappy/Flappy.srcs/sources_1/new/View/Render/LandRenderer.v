module LandRenderer# (
    parameter LATENCY = 0
) (
    input  [15:0] screen_x, screen_y,
    input  [31:0] game_x, game_y,
    input  [11:0] col_in,
    output [ 9:0] addr,
    output        mask,
    output [11:0] col_out
);

assign mask = game_y[9];
wire [4:0] land_x = ($signed(game_x + 384) % 24) >>> 1;  // how to avoid %?
wire [4:0] land_y = ($unsigned((screen_y - 401) >> 1) > $unsigned(11)) ? 11 : $unsigned((screen_y - 401) >> 1);
assign addr = mask ? (($unsigned(land_x) < 12 && $unsigned(land_y) < 12) ? (land_x + 12 * land_y) : 143) : 256;

assign col_out = {12{land_y <= 8}} & col_in
               | {12{land_y == 9}} & 12'h582
               | {12{land_y == 10}} & 12'hDA4
               | {12{land_y >= 11}} & 12'hDD9;
endmodule