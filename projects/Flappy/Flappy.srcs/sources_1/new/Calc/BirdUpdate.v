module BirdUpdate#(
    parameter BIRD_HSPEED = 3,
    parameter BIRD_INITAIL_Y = 176
)(
    input clk,
    input rstn,
    input upd,
    input [2:0] p1_input,
    input [1:0] game_status,
    output finish,
    output reg [31:0] bird_x,
    output [1:0] bird_animation,
    output [7:0] bird_rotation,
    output reg [31:0] p1_bird_y,
    output reg [31:0] p1_bird_velocity
);
// 鸟相关量的计算模块。
// 主要计算：鸟的 y 坐标变化、鸟的 x 世界坐标变化、鸟的动画。
// 也可以分出多个子模块进行实现。
assign finish = 1'b1;

reg [4:0] bird_anim_cnt;
assign bird_animation = bird_anim_cnt[4:3];
assign bird_rotation = 0;

reg idle_dir = 0;
always @(posedge clk) begin
    if(~rstn) begin
        bird_x <= 0;
        bird_anim_cnt <= 0;
        p1_bird_y[31:16] <= BIRD_INITAIL_Y;
        p1_bird_y[15:0]  <= 16'b0;
        p1_bird_velocity <= 32'b0;
    end else begin
        if(upd) begin 
            bird_x <= bird_x + BIRD_HSPEED;
            bird_anim_cnt <= bird_anim_cnt + 1;
            // 这个其实是 game_status==2'b01 时的行为（上下移动）。到时候实现的时候直接抄就好。
            if(idle_dir == 0) begin
                p1_bird_y <= p1_bird_y + 31'h00008000;  // 加上的数是 0.5
            end else begin
                p1_bird_y <= p1_bird_y - 31'h00008000;
            end
            if(p1_bird_y[31:16] >= BIRD_INITAIL_Y + 6) begin
                idle_dir <= 1;
            end
            else if(p1_bird_y[31:16] <= BIRD_INITAIL_Y - 6) begin
                idle_dir <= 0;
            end
        end
    end
end

endmodule