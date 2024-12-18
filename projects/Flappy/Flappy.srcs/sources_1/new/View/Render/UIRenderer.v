module UIRenderer#(
    parameter LATENCY = 0
) (
    input  [15:0] screen_x, screen_y,
    input  [15:0] col_in,

    input  [1:0] game_status,
    input  [31:0] timer,
    input  [31:0] gameover_timestamp,


    output [13:0] addr,
    output        mask,
    output [15:0] col_out
);

localparam text_center_x = 144, text_center_y = 160;
localparam tuto_center_x = 144, tuto_center_y = 256;
localparam tuto_w = 57, tuto_h = 42;
localparam gameover_w = 96, gameover_h = 21;
localparam ready_w = 92, ready_h = 25;
localparam tuto_x0 = tuto_center_x - tuto_w, 
           tuto_x1 = tuto_center_x + tuto_w - 1, 
           tuto_y0 = tuto_center_y - tuto_h, 
           tuto_y1 = tuto_center_y + tuto_h - 1;
localparam gameover_x0 = text_center_x - gameover_w, 
           gameover_x1 = text_center_x + gameover_w, 
           gameover_y0 = text_center_y - gameover_h, 
           gameover_y1 = text_center_y + gameover_h - 1;
localparam ready_x0 = text_center_x - ready_w, 
           ready_x1 = text_center_x + ready_w, 
           ready_y0 = text_center_y - ready_h, 
           ready_y1 = text_center_y + ready_h - 1;
wire tuto_frame = ~timer[5];
wire tuto_mask =     (game_status == 2'b01) & (($signed(screen_x) >= tuto_x0) &&     ($signed(screen_x - LATENCY) <= tuto_x1) &&     ($signed(screen_y) >= tuto_y0) &&     ($signed(screen_y) <= tuto_y1));
wire ready_mask =    (game_status == 2'b01) & (($signed(screen_x) >= ready_x0) &&    ($signed(screen_x - LATENCY) <= ready_x1) &&    ($signed(screen_y) >= ready_y0) &&    ($signed(screen_y) <= ready_y1));
wire gameover_mask = (game_status == 2'b11) & (($signed(screen_x) >= gameover_x0) && ($signed(screen_x - LATENCY) <= gameover_x1) && ($signed(screen_y) >= gameover_y0) && ($signed(screen_y) <= gameover_y1));
wire [12:0] tuto_x = (screen_x - tuto_x0) >> 1, tuto_y = (screen_y - tuto_y0) >> 1;
wire [12:0] gameover_x = (screen_x - gameover_x0) >> 1, gameover_y = (screen_y - gameover_y0) >> 1;
wire [12:0] ready_x = (screen_x - ready_x0) >> 1, ready_y = (screen_y - ready_y0) >> 1;
wire [13:0] tuto_addr =     tuto_x + tuto_w * tuto_y + 57 * 42 * tuto_frame;
wire [13:0] gameover_addr = 14'd4788 + gameover_x + gameover_w * gameover_y;
wire [13:0] ready_addr =    14'd6804 + ready_x + ready_w * ready_y;
wire [31:0] gameover_delta_time = timer - gameover_timestamp;
wire [31:0] alpha_time = $signed(gameover_delta_time) < 0 ? 0 :
                         $signed(gameover_delta_time) > 31 ? 31 : 
                         $signed(gameover_delta_time);

assign addr = tuto_addr & {14{tuto_mask}} 
            | gameover_addr & {14{gameover_mask}} 
            | ready_addr & {14{ready_mask}};
assign mask = (tuto_mask | gameover_mask | ready_mask) & col_in[3];
assign col_out = {col_in[15:4], (col_in[3:0] & {4{mask}} & ({4{game_status != 2'b11}} | alpha_time[4:1]))};
endmodule