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
assign passed = bird_x >= tube_pos + TUBE_HITBOX_R;
assign collide = 
    ($signed(p1_bird_y) <= $signed(14)) 
    || (   ($signed(bird_x) <= $signed(tube_pos + TUBE_HITBOX_R + 12))
        && ($signed(bird_x) >= $signed(tube_pos + TUBE_HITBOX_L - 12))
        && ( ($signed(p1_bird_y) <= $signed(tube_height + 12)
           || $signed(p1_bird_y) >= $signed(tube_height + tube_spacing - 12))));
endmodule