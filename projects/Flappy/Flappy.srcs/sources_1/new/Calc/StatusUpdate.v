module StatusUpdate(
    input clk,
    input rstn,
    input upd,
    input retry,
    input god_mode,
    input [2:0] p1_input,
    input [31:0] bird_x,
    input [15:0] p1_bird_y,
    input [31:0] tube_pos,
    input [15:0] tube_height,
    input [7:0]  tube_spacing,
    input [31:0] timer,
    output reg [31:0] gameover_timestamp,
    output reg finish,
    output reg [15:0] score,
    output reg [11:0] score_decimal,
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
        score_decimal <= 0;
        finish = 0;
        gameover_timestamp <= 0;
    end else begin
        if(retry) begin
            game_status <= 2'b00;
        end
        if(upd) begin
            case(game_status)
            2'b00: begin
                game_status <= 2'b01;
                score <= 0;
                score_decimal <= 0;
                gameover_timestamp <= 0;
            end
            2'b01: begin
                if(p1_input[0]) begin
                    game_status <= 2'b10;
                end
            end
            2'b10: begin
                if(~god_mode & collide) begin
                    game_status <= 2'b11;
                    gameover_timestamp <= timer;
                end
                if(passed) begin
                    score <= score + 1;
                    // 8421BCD 计数器
                    if(score_decimal != 12'b100110011001) begin
                        if(score_decimal[3:0] == 4'b1001) begin
                            score_decimal[3:0] <= 0;
                            if(score_decimal[7:4] == 4'b1001) begin
                                score_decimal[7:4] <= 0;
                                score_decimal[11:8] <= score_decimal[11:8] + 1;
                            end else begin
                                score_decimal[7:4] <= score_decimal[7:4] + 1;
                            end
                        end else begin
                            score_decimal[3:0] <= score_decimal[3:0] + 1;
                        end
                    end
                    // 如果分数超出 999，则显示的分数不再增加。
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