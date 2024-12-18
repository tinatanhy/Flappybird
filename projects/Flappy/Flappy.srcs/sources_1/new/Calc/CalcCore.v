module CalcCore#(
    parameter BIRD_HSPEED = 2,
    parameter N_TUBE = 4,
    parameter IND_TUBE_INTERACT = 1
)(
    input clk,
    input rstn,
    input btn,
    input upd,
    input retry,
    input god_mode,
    input debug_speed_boost,
    input [15:0] world_seed_input,
    output [2:0]      calc_status,
    output [15:0]        calc_debug_led,
    output [31:0]        calc_debug_seg,
    output reg finish,
    output    [31:0]             timer_output,
    output reg [31:0]       gameover_timestamp_output,
    output reg [1:0]       game_status_output,
    output reg [15:0]       world_seed_output,
    output reg [15:0]            score_output,
    output reg [11:0]    score_decimal_output,
    output reg [31:0]        tube_pos0_output,
    output reg [15:0]     tube_height0_output,
    output reg [7:0]     tube_spacing0_output,
    output reg [31:0]        tube_pos1_output,
    output reg [15:0]     tube_height1_output,
    output reg [7:0]     tube_spacing1_output,
    output reg [31:0]        tube_pos2_output,
    output reg [15:0]     tube_height2_output,
    output reg [7:0]     tube_spacing2_output,
    output reg [31:0]        tube_pos3_output,
    output reg [15:0]     tube_height3_output,
    output reg [7:0]     tube_spacing3_output,
    output reg [31:0]         camera_x_output,
    output reg [31:0]           bird_x_output,
    output reg [31:0]        p1_bird_y_output,
    output reg [31:0] p1_bird_velocity_output,
    output reg [15:0]        bg_xshift_output,
    output reg [1:0]    bird_animation_output,
    output reg [7:0]     bird_rotation_output,
    output reg [2:0]          p1_input_output,
    output reg [7:0]       shake_x_output,
    output reg [7:0]       shake_y_output
);
// CalcCore: 各个子模块的调度模块
reg     input_gdata_upd,
        bird_tube_upd,
        status_upd;
wire    input_finish, 
        globaldata_finish, 
        bird_update_finish, 
        tube_update_finish, 
        status_update_finish;

// BEGIN STATE MACHINE
// 000: 等待 upd
// 001: 向 KeyInput 发送更新信号并转移至 010
// 010: 等待 KeyInput 完成
// 011: 向 BirdUpdate 和 TubeUpdate 发送更新信号并转移至 100
// 100: 等待 BirdUpdate 和 TubeUpdate 完成
// 101: 向 StatusUpdate 发送更新信号并转移至 110
// 110: 等待 StatusUpdate 完成
// 111: 设置 finish 为 1
reg [2:0] submodule_status;
reg [2:0] submodule_status_next;
reg [15:0] world_seed;
reg [31:0] timer;
// assign finish = (submodule_status == 3'b111);
assign calc_status = submodule_status;

always @(posedge clk) begin
    if (!rstn) begin
        submodule_status <= 3'b000;
        timer <= 0;
    end else begin
        submodule_status <= submodule_status_next;
        if(upd) begin
            timer <= timer + 1;
            world_seed <= world_seed_input;
        end
    end
end

always @(*) begin
    submodule_status_next = submodule_status;
    case(submodule_status)
        3'b000: begin
            if(upd) begin
                submodule_status_next = 3'b001;
            end
        end
        3'b001: begin
            submodule_status_next = 3'b010;
        end
        3'b010: begin
            if(input_finish && globaldata_finish) begin
                submodule_status_next = 3'b011;
            end
        end
        3'b011: begin
            submodule_status_next = 3'b100;
        end
        3'b100: begin
            if(bird_update_finish && tube_update_finish) begin
                submodule_status_next = 3'b101;
            end
        end
        3'b101: begin
            submodule_status_next = 3'b110;
        end
        3'b110: begin
            if(status_update_finish) begin
                submodule_status_next = 3'b111;
            end
        end
        3'b111: begin
            submodule_status_next = 3'b000;
        end
    endcase
end

always @(*) begin
    input_gdata_upd = 1'b0;
    bird_tube_upd = 1'b0;
    status_upd = 1'b0;
    finish = 1'b0;
    case(submodule_status) 
        3'b001: begin
            input_gdata_upd = 1'b1;
        end
        3'b011: begin
            bird_tube_upd = 1'b1;
        end
        3'b101: begin
            status_upd = 1'b1;
        end
        3'b111: begin
            finish = 1'b1;
        end
        default;
    endcase
end
// END STATE MACHINE

// BEGIN SUBMODULES
wire [2:0] p1_input;
wire [1:0] game_status;
wire [31:0] bird_x;
wire [31:0] bird_start_x;
wire [31:0] p1_bird_y;
wire [31:0] p1_bird_velocity;
wire [31:0] tube_pos      [N_TUBE-1:0];
wire [15:0] tube_height   [N_TUBE-1:0];
wire [7:0]  tube_spacing  [N_TUBE-1:0];
wire [15:0] score;
wire [11:0] score_decimal;
wire [1:0] bird_animation;
wire [7:0] bird_rotation;
wire [15:0] bg_xshift;
wire [7:0] shake_x;
wire [7:0] shake_y;
wire [31:0] gameover_timestamp;
KeyInput input_p1(
    .upd        (input_gdata_upd),
    .btn        (btn),
    .rstn       (rstn),
    .pressed    (p1_input[0]),
    .check      (p1_input[1]),
    .released   (p1_input[2]),
    .finish     (input_finish)
);
GlobalDataUpdate globaldata(
    .clk        (clk),
    .rstn       (rstn),
    .upd        (input_gdata_upd),
    .game_status(game_status),
    .timer      (timer),
    .gameover_timestamp(gameover_timestamp),
    .shake_x    (shake_x),
    .shake_y    (shake_y),
    .finish     (globaldata_finish)
);
BirdUpdate#(
    .BIRD_HSPEED (BIRD_HSPEED)
) bird_update(
    .clk              (clk),
    .rstn             (rstn),
    .upd              (bird_tube_upd),
    .hspeed_boost     (debug_speed_boost),
    .p1_input         (p1_input),
    .game_status      (game_status),
    .finish           (bird_update_finish),
    .bird_x           (bird_x),
    .p1_bird_y        (p1_bird_y),
    .p1_bird_velocity (p1_bird_velocity),
    .bird_animation   (bird_animation),
    .bird_rotation    (bird_rotation),
    .bird_start_x     (bird_start_x),
    .bg_xshift        (bg_xshift)
);

assign calc_debug_seg = 16'b0;
TubeUpdate tube_update(
    .clk           (clk),
    .rstn          (rstn),
    .upd           (bird_tube_upd),
    .seed          (world_seed[12:0]),
    .score         (score_output), // 为了稳定性
    .finish        (tube_update_finish),
    .debug_status  (calc_debug_led),
    .bird_start_x  (bird_start_x),
    .tube_pos0     (tube_pos[0]),
    .tube_height0  (tube_height[0]),
    .tube_spacing0 (tube_spacing[0]),
    .tube_pos1     (tube_pos[1]),
    .tube_height1  (tube_height[1]),
    .tube_spacing1 (tube_spacing[1]),
    .tube_pos2     (tube_pos[2]),
    .tube_height2  (tube_height[2]),
    .tube_spacing2 (tube_spacing[2]),
    .tube_pos3     (tube_pos[3]),
    .tube_height3  (tube_height[3]),
    .tube_spacing3 (tube_spacing[3])
);
StatusUpdate status_update(
    .clk          (clk),
    .rstn         (rstn),
    .upd          (status_upd),
    .retry        (retry),
    .timer        (timer),
    .god_mode     (god_mode),
    .gameover_timestamp (gameover_timestamp),
    .p1_input     (p1_input),
    .bird_x       (bird_x),
    .p1_bird_y    (p1_bird_y[31:16]),
    .tube_pos     (tube_pos[IND_TUBE_INTERACT]),
    .tube_height  (tube_height[IND_TUBE_INTERACT]),
    .tube_spacing (tube_spacing[IND_TUBE_INTERACT]),
    .score        (score),
    .score_decimal(score_decimal),
    .game_status  (game_status),
    .finish       (status_update_finish)
);

assign timer_output = timer;
reg lock;
initial begin
    lock = 1;
end
always @(posedge clk) begin
    if(!rstn || (submodule_status == 3'b111 && !lock)) begin
             game_status_output <=      game_status;
                   score_output <=            score;
           score_decimal_output <=    score_decimal;
               tube_pos0_output <=      tube_pos[0];        
            tube_height0_output <=   tube_height[0];
           tube_spacing0_output <=  tube_spacing[0];
               tube_pos1_output <=      tube_pos[1];
            tube_height1_output <=   tube_height[1];
           tube_spacing1_output <=  tube_spacing[1];
               tube_pos2_output <=      tube_pos[2];
            tube_height2_output <=   tube_height[2];
           tube_spacing2_output <=  tube_spacing[2];        
               tube_pos3_output <=      tube_pos[3];
            tube_height3_output <=   tube_height[3];
           tube_spacing3_output <=  tube_spacing[3];
                camera_x_output <=           bird_x;
                  bird_x_output <=           bird_x;
               p1_bird_y_output <=        p1_bird_y;
        p1_bird_velocity_output <= p1_bird_velocity;
               p1_input_output  <=         p1_input;
               bg_xshift_output <=        bg_xshift;
          bird_animation_output <=   bird_animation;
           bird_rotation_output <=    bird_rotation;
             world_seed_output  <=       world_seed;
             shake_x_output     <=       shake_x;
             shake_y_output     <=       shake_y;
        gameover_timestamp_output <= gameover_timestamp;
        lock <= 1;
    end else if(submodule_status == 3'b000) begin
        lock <= 0;
    end
end
// END SUBMODULES
endmodule