module CalcCore#(
    parameter N_TUBE = 4,
    parameter IND_TUBE_INTERACT = 1
)(
    input clk,
    input rstn,
    input btn,
    input upd,
    input [15:0] world_seed,
    output finish
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

// 状态机
// 00: 接收到 upd 时发送一次 input_gdata_upd
// 01: 切换到时发送一次 bird_tube_upd
// 10: 切换到时发送一次 status_upd
// 11: 空闲或完成计算，输出 finish
reg [1:0] submodule_status;
reg [1:0] submodule_status_next;
assign finish = (submodule_status == 2'b11);

// 调度状态机。这里将切换和状态切换时的行为写在了一起。
always @(posedge clk) begin
    input_gdata_upd <= 1'b0;
    bird_tube_upd   <= 1'b0;
    status_upd      <= 1'b0;
    if (!rstn) begin
        submodule_status <= 2'b11;
    end else begin
        if(submodule_status != submodule_status_next) begin
            submodule_status <= submodule_status_next;
            if(submodule_status_next == 2'b00) begin
                input_gdata_upd <= 1'b1;    // 仅输出 1 时钟周期
            end
            if(submodule_status_next == 2'b01) begin
                bird_tube_upd <= 1'b1;
            end 
            else if(submodule_status_next == 2'b10) begin
                status_upd <= 1'b1;
            end
        end
    end
end

// 下一状态的决定
always @(*) begin
    submodule_status_next = submodule_status;
    case(submodule_status)
        2'b00: begin
            if(input_finish && globaldata_finish) begin
                submodule_status_next = 2'b01;
            end
        end
        2'b01: begin
            if(bird_update_finish && tube_update_finish) begin
                submodule_status_next = 2'b10;
            end
        end
        2'b10: begin
            if(status_update_finish) begin
                submodule_status_next = 2'b11;
            end
        end
        2'b11: begin
            if(upd) begin
                submodule_status_next = 2'b00;
            end
        end
    endcase
end

wire [2:0] p1_input;
wire [1:0] game_status;
wire [31:0] bird_x;
wire [31:0] p1_bird_y;
wire [31:0] p1_bird_velocity;
wire [31:0] tube_pos      [N_TUBE-1:0];
wire [15:0] tube_height   [N_TUBE-1:0];
wire [7:0]  tube_spacing  [N_TUBE-1:0];
wire [15:0] score;
KeyInput input_p1(
    .upd        (input_gdata_upd),
    .btn        (btn),
    .pressed    (p1_input[0]),
    .check      (p1_input[1]),
    .released   (p1_input[2]),
    .finish     (input_finish)
);
GlobalDataUpdate globaldata(
    .clk        (clk),
    .rstn       (rstn),
    .upd        (input_gdata_upd),
    .finish     (globaldata_finish)
);
BirdUpdate bird_update(
    .clk        (clk),
    .rstn       (rstn),
    .upd        (bird_tube_upd),
    .p1_input   (p1_input),
    .game_status(game_status),
    .finish     (bird_update_finish),
    .bird_x     (bird_x),
    .p1_bird_y  (p1_bird_y),
    .p1_bird_velocity(p1_bird_velocity)
);
TubeUpdate tube_update(
    .clk        (clk),
    .rstn       (rstn),
    .upd        (bird_tube_upd),
    .seed       (world_seed[12:0]),
    .score      (score),
    .finish     (tube_update_finish),
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
    .clk        (clk),
    .rstn       (rstn),
    .upd        (status_upd),
    .p1_input   (p1_input),
    .bird_x     (bird_x),
    .p1_bird_y  (p1_bird_y),
    .tube_pos    (tube_pos[IND_TUBE_INTERACT]),
    .tube_height (tube_height[IND_TUBE_INTERACT]),
    .tube_spacing(tube_spacing[IND_TUBE_INTERACT]),
    .score      (score),
    .game_status(game_status),
    .finish     (status_update_finish)
);

endmodule