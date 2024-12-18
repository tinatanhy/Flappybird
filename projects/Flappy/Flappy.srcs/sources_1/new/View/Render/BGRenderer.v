module BGRenderer#(
    parameter LATENCY = 0
) (
    input  [15:0] screen_x, screen_y,
    input  [15:0] game_x, game_y,
    input  [15:0] world_seed,
    input  [11:0] col_in,
    output [16:0] addr,
    output        mask,
    output [11:0] col_out
);

assign mask = ($signed(screen_x - LATENCY) >= $signed(1) && $signed(screen_y) >= $signed(0) && $signed(screen_x - LATENCY) < $signed(288) && $signed(screen_y) < $signed(512));
assign addr = ((screen_x + 1) >> 1) + ((screen_y >> 1) << 4) + ((screen_y >> 1) << 7) + ({16'b0, world_seed[15]} << 12) + ({16'b0, world_seed[15]} << 15);
assign col_out = col_in;

endmodule