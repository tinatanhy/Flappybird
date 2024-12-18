module BirdRenderer#(
    parameter LATENCY = 0
) (
    input  [15:0] screen_x, screen_y,
    input  [15:0] world_seed,
    input  [15:0] col_in_00,
    input  [15:0] col_in_01,
    input  [15:0] col_in_02,

    input [31:0]           bird_x,
    input [31:0]         camera_x,
    input [31:0]        p1_bird_y,
    input [1:0]    bird_animation,
    input [7:0]     bird_rotation,

    output [15:0] addr,
    output        mask,
    output [15:0] col_out
);

wire [1:0] bird_color = (&world_seed[14:13]) ? 2'b00 : world_seed[14:13];
wire [1:0] bird_anim =  (&bird_animation) ? 2'b01 : bird_animation;
wire [15:0] p1_bird_x_screen = 80 + bird_x - camera_x;
wire [15:0] p1_bird_y_screen = 400 - p1_bird_y[31:16];
wire [15:0] x_in_bird = $signed(screen_x - p1_bird_x_screen + 20);
wire [15:0] y_in_bird = $signed(screen_y - p1_bird_y_screen + 20);
wire [15:0] col_bird = {16{bird_animation == 2'b00}} & col_in_00
                        | {16{(bird_animation == 2'b01 || bird_animation == 2'b11)}} & col_in_01
                        | {16{bird_animation == 2'b10}} & col_in_02;

assign mask = (screen_x >= 80 - 20) && (screen_x <= 80 + 20) 
                  && ($signed(y_in_bird) >= $signed(0)) 
                  && ($signed(y_in_bird) <= $signed(40));
assign addr = (x_in_bird + (y_in_bird << 5) + (y_in_bird << 3) + (bird_rotation << 10) + (bird_rotation << 9) + (bird_rotation << 6)) & {16{mask}};
assign col_out = { col_bird[15:4], {4{mask}} & col_bird[3:0] };
endmodule