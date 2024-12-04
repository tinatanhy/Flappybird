module CollisionCheck(
    input [31:0] tube_pos,
    input [15:0] tube_height,
    input [7:0] tube_spacing,
    input [31:0] bird_x,
    input [15:0] p1_bird_y,
    output collide,
    output passed
);
// TODO
assign collide = 0;
assign passed = 0;
endmodule