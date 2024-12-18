module BirdUpdate#(
    parameter BIRD_HSPEED = 2,
    parameter BG_XRANGE = 12,
    parameter BIRD_INITAIL_Y = 176,
    parameter BIRD_MINIMUM_Y = 14,
    parameter BIRD_MAXIMUM_Y = 420,
    parameter BIRD_MAX_VELOCITY = 32'h00060000
)(
    input clk,
    input rstn,
    input upd,
    input [2:0] p1_input,
    input [1:0] game_status,
    input hspeed_boost,
    output finish,
    output reg [31:0] bird_x,
    output reg [31:0] bird_start_x,
    output [1:0] bird_animation,
    output reg [7:0] bird_rotation,
    output reg [31:0] p1_bird_y,
    output reg [31:0] p1_bird_velocity,
    output [15:0] bg_xshift
);
assign bg_xshift = 0;       // 不会被用到

// 鸟相关量的计算模块。
// 主要计算：鸟的 y 坐标变化、鸟的 x 世界坐标变化、鸟的动画。
// 因为比较相关所以背景计算也放在这里。可能比较乱。
// 也可以分出多个子模块进行实现。
assign finish = 1'b1;

reg [31:0] p1_bird_velparam;
reg [31:0] p1_bird_velparam_delayed;
reg [4:0] bird_anim_cnt;

assign bird_animation = bird_anim_cnt[4:3];

localparam PARAM_LERP = 20;
localparam PARAM_MULT = 53;

// 移动部分
reg idle_dir = 0;
always @(posedge clk) begin
    if(~rstn) begin
        bird_x <= 0;
        p1_bird_y[31:16] <= BIRD_INITAIL_Y;
        p1_bird_y[15:0]  <= 0;
        p1_bird_velocity <= 32'b0;
        bird_start_x <= 65535;
    end else begin
        if(upd) begin 
            case(game_status)
            2'b00: begin
                bird_start_x <= 65535;
                bird_x <= 0;
                p1_bird_y[31:16] <= BIRD_INITAIL_Y;
                p1_bird_y[15:0]  <= 0;
                p1_bird_velocity <= 32'b0;
            end
            2'b01: begin
                // 开始界面。鸟上下移动。
                // 这个其实是 game_status==2'b01 时的行为（上下移动）。到时候实现的时候直接抄就好。
                if(hspeed_boost) begin
                    bird_x <= bird_x + BIRD_HSPEED * 20; // 世界坐标向右移动
                end else begin
                    bird_x <= bird_x + BIRD_HSPEED;     // 世界坐标向右移动
                end
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

                bird_start_x <= bird_x;

                if(p1_input[0])begin
                    if(p1_bird_y < BIRD_MINIMUM_Y)begin
                        p1_bird_y[31:16] <= BIRD_MINIMUM_Y;
                        p1_bird_y[15:0] <= 0;
                    end
                    p1_bird_velocity <= BIRD_MAX_VELOCITY;
                end else begin
                    p1_bird_velocity <= 0;
                end
            end 
            2'b10: begin
                if(p1_input[0])begin
                    if($signed(p1_bird_y[31:16]) < $signed(BIRD_MINIMUM_Y))begin
                        p1_bird_y[31:16] <= BIRD_MINIMUM_Y;
                        p1_bird_y[15:0] <= 0;
                    end
                    p1_bird_velocity <= BIRD_MAX_VELOCITY;
                end else begin
                    if($signed(p1_bird_y[31:16] + p1_bird_velocity[31:16]) < $signed(BIRD_MINIMUM_Y))begin
                        p1_bird_y[31:16] <= BIRD_MINIMUM_Y;
                        p1_bird_y[15:0] <= 0;
                        p1_bird_velocity <= 0;
                    end else if($signed(p1_bird_y[31:16] + p1_bird_velocity[31:16]) > $signed(BIRD_MAXIMUM_Y)) begin
                        p1_bird_y[31:16] <= BIRD_MAXIMUM_Y;
                        p1_bird_y[15:0] <= 0;
                        p1_bird_velocity <= 0;
                    end else begin
                        p1_bird_y <= p1_bird_y + p1_bird_velocity;
                        p1_bird_velocity <= p1_bird_velocity - 32'h00004400;
                    end
                end
                if(hspeed_boost) begin
                    bird_x <= bird_x + BIRD_HSPEED * 20; // 世界坐标向右移动
                end else begin
                    bird_x <= bird_x + BIRD_HSPEED;     // 世界坐标向右移动
                end
            end
            2'b11: begin
                // GAME OVER 状态。
                // 暂时什么也不做。(Checkpoint 2)
                // 可能需要鸟下坠。(Checkpoint 3)
                if($signed(p1_bird_y[31:16] + p1_bird_velocity[31:16]) <= $signed(BIRD_MINIMUM_Y)) begin
                    p1_bird_y[31:16] <= BIRD_MINIMUM_Y;
                    p1_bird_y[15:0] <= 0;
                    p1_bird_velocity <= 0;
                end else begin
                    if($signed(p1_bird_velocity) > 0) begin
                        p1_bird_velocity <= 0;
                        p1_bird_y <= p1_bird_y;
                    end else begin
                        p1_bird_velocity <= p1_bird_velocity - 32'h00005000;
                        p1_bird_y <= p1_bird_y + p1_bird_velocity;
                    end
                end
                bird_x <= bird_x;                   // 世界坐标不再移动
            end
            default;
            endcase
        end
    end
end

// 动画部分
// 该部分时序违例，需要进一步改写为时序逻辑。
reg [31:0] p1_velparam_temp;
always @(posedge clk) begin
    if(~rstn) begin
        bird_anim_cnt <= 0;
        p1_velparam_temp <= {16'd15, 16'b0};
        p1_bird_velparam[31:16] <= 16'd15;
        p1_bird_velparam[16:0] <= 0;
        p1_bird_velparam_delayed[31:16] <= 16'd15;
        p1_bird_velparam_delayed[16:0] <= 0;
        bird_rotation <= 11;
    end else begin
        if(upd) begin 
            p1_velparam_temp <= ($signed(-p1_bird_velocity) >>> 3) * PARAM_MULT + {16'd15, 16'b0};

            case(game_status)
            2'b00: begin
                bird_anim_cnt <= 0;
                p1_bird_velparam[31:16] <= 16'd15;
                p1_bird_velparam[16:0] <= 0;
                p1_bird_velparam_delayed[31:16] <= 16'd15;
                p1_bird_velparam_delayed[16:0] <= 0;
            end
            2'b01: begin
                bird_anim_cnt <= bird_anim_cnt + 1;
                p1_bird_velparam[31:16] <= 16'd15;
                p1_bird_velparam[16:0] <= 0;
                p1_bird_velparam_delayed[31:16] <= 16'd15;
                p1_bird_velparam_delayed[16:0] <= 0;
            end 
            2'b10: begin
                bird_anim_cnt <= bird_anim_cnt + 1; // 播放动画
                if($signed(p1_velparam_temp) < $signed(1)) begin
                    p1_bird_velparam <= 32'd1;
                end else if($signed(p1_velparam_temp[31:16]) > $signed(36)) begin
                    p1_bird_velparam[31:16] <= 16'd36;
                    p1_bird_velparam[16:0] <= 0;
                end else begin
                    p1_bird_velparam <= p1_velparam_temp;
                end
                p1_bird_velparam_delayed <= (p1_bird_velparam_delayed >>> 7) * (128 - PARAM_LERP) + (p1_bird_velparam >>> 7) * PARAM_LERP;
            end
            2'b11: begin
                bird_anim_cnt <= bird_anim_cnt + 1; // 播放动画
                p1_bird_velparam[31:16] <= 16'd37;
                p1_bird_velparam[16:0] <= 0;
                p1_bird_velparam_delayed <= (p1_bird_velparam_delayed >>> 7) * (128 - PARAM_LERP) + (p1_bird_velparam >>> 7) * PARAM_LERP;
            end
            default;
            endcase

            if($signed(p1_bird_velparam_delayed[31:16] + 1) < $signed(4)) begin
                bird_rotation <= 8'd29;
            end else if ($signed(p1_bird_velparam_delayed[31:16] + 1) > $signed(33)) begin
                bird_rotation <= 8'd0;
            end else begin
                bird_rotation <= 8'd32 - p1_bird_velparam_delayed[23:16];
            end
        end
    end
end


endmodule