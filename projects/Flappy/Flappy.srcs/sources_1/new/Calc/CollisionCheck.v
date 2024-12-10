module CollisionCheck(
    input [31:0] tube_pos,
    input [15:0] tube_height,
    input [7:0] tube_spacing,
    input [31:0] bird_x,
    input [15:0] p1_bird_y,
    output collide,
    output passed
);

parameter TUBE_HITBOX_L = 2;
parameter TUBE_HITBOX_R = 50;
assign passed = $unsigned(bird_x) >= $unsigned(tube_pos + TUBE_HITBOX_R);

// TODO
assign collide = ($signed(p1_bird_y) < 0) || 1'b0/*TODO*/;
endmodule