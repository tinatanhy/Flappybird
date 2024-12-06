module StatusUpdate(
    input clk,
    input rstn,
    input upd,
    input [2:0] p1_input,
    input [31:0] bird_x,
    input [31:0] p1_bird_y,
    input [31:0] tube_pos,
    input [15:0] tube_height,
    input [7:0]  tube_spacing,
    output finish,
    output [15:0] score,
    output [1:0] game_status
);
// TODO
assign finish = 1'b1;
assign score = bird_x - 40 <= 0 ? 0 : ((bird_x - 40) >> 6);
assign game_status = 2'b10;
wire collide, passed;
CollisionCheck collidsionCheck(
    .tube_pos(tube_pos),
    .tube_height(tube_height),
    .tube_spacing(tube_spacing),
    .bird_x(bird_x),
    .p1_bird_y(p1_bird_y),
    .collide(collide),
    .passed(passed)
);

always @(posedge clk) begin
    if(rstn) begin
        game_status <= 2'b01;   // 后续会设置为 2'b00
    end else begin
        if(upd) begin
            case(game_status)
            2'b00: begin
                game_status <= 2'b01;
            end
            2'b01: begin
                if(p1_input[0]) begin
                    game_status <= 2'b10;
                end
            end
            2'b10: begin
                if(collide) begin
                    game_status <= 2'b11;
                end
                if(passed) begin
                    score <= score + 1;
                end
            end
            2'b11: begin
                // Do Nothing
            end
            endcase
        end
    end
end
endmodule