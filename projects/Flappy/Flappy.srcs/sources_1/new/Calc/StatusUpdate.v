module StatusUpdate(
    input clk,
    input rstn,
    input upd,
    input retry,
    input [2:0] p1_input,
    input [31:0] bird_x,
    input [31:0] p1_bird_y,
    input [31:0] tube_pos,
    input [15:0] tube_height,
    input [7:0]  tube_spacing,
    output reg finish,
    output reg [15:0] score,
    output reg [1:0] game_status
);
// TODO
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
    if(~rstn) begin
        game_status <= 2'b00;   // 后续会设置为 2'b00
        score <= 0;
        finish = 0;
    end else begin
        if(retry) begin
            game_status <= 2'b00;
        end
        if(upd) begin
            case(game_status)
            2'b00: begin
                game_status <= 2'b01;
                score <= 0;
            end
            2'b01: begin
                if(p1_input[0]) begin
                    game_status <= 2'b10;
                end
                if(passed) begin
                    score <= score + 1;
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
                if(p1_input[0]) begin
                    game_status <= 2'b00;
                end
            end
            endcase
            finish <= 1;
        end
    end
end
endmodule