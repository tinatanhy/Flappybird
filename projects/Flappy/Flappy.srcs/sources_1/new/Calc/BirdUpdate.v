module BirdUpdate(
    input clk,
    input rstn,
    input upd,
    input [2:0] p1_input,
    input [1:0] game_status,
    output finish,
    output [31:0] bird_x,
    output [31:0] p1_bird_y,
    output [31:0] p1_bird_velocity
);
assign finish = 1'b1;
assign bird_x = 0;
assign p1_bird_y = 200;
assign p1_bird_velocity = 0;
endmodule