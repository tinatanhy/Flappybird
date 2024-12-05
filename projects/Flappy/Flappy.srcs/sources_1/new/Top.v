module Top(
    input CLK100MHZ, CPU_RESETN, BTNC, BTNU, BTND, BTNL, BTNR,
    input [15:0] SW,
    output VGA_HS, VGA_VS,
    output [15:0] LED,
    output [3:0] VGA_R, VGA_G, VGA_B
);
parameter N_TUBE = 4;
parameter IND_TUBE_INTERACT = 1;
wire clk = CLK100MHZ;
wire rstn = CPU_RESETN;
wire btn = BTNC;
wire wdata_finish, calc_finish;
wire [2:0] calc_status;
wire [6:0] calc_counter1;
wire [15:0] world_seed_input;
wire [15:0]       world_seed;
wire [1:0]       game_status;
wire [15:0]            score;
wire [31:0]        tube_pos0;
wire [15:0]     tube_height0;
wire [7:0]     tube_spacing0;
wire [31:0]        tube_pos1;
wire [15:0]     tube_height1;
wire [7:0]     tube_spacing1;
wire [31:0]        tube_pos2;
wire [15:0]     tube_height2;
wire [7:0]     tube_spacing2;
wire [31:0]        tube_pos3;
wire [15:0]     tube_height3;
wire [7:0]     tube_spacing3;
wire [31:0]           bird_x;
wire [31:0]         camera_x;
wire [31:0]        p1_bird_y;
wire [31:0] p1_bird_velocity;
wire [2:0]          p1_input;
wire [15:0]        bg_xshift;
wire [1:0]    bird_animation;
wire [7:0]     bird_rotation;

// Retry Module
wire retry_pressed, retry_upd;
Button button_retry(
    .clk(upd),
    .btn(BTNU),
    .pressed(retry_pressed)
);
PS retry_ps(
    .clk(upd),
    .s(retry_pressed),
    .p(retry_upd)
);
// End Retry Module

wire upd;
FrameClock frameclk(
    .clk        (clk),
    .rstn       (rstn),
    .clk_out    (upd)
);

WorldData worlddata(
    .clk        (clk),
    .rstn       (rstn),
    .upd        (retry_upd),
    .finish     (wdata_finish),
    .world_seed (world_seed_input)
);

CalcCore#(
    .N_TUBE(N_TUBE),
    .IND_TUBE_INTERACT(IND_TUBE_INTERACT)
) calccore(
    .clk                     (clk),
    .rstn                    (rstn),
    .btn                     (btn),
    .upd                     (upd),

    .finish                  (calc_finish),
    .calc_status             (calc_status),
    .calc_counter1           (calc_counter1),

    .world_seed_input        (world_seed_input),
    .world_seed_output       (world_seed),
    .game_status_output      (game_status),
    .score_output            (score),
    .tube_pos0_output        (tube_pos0),
    .tube_height0_output     (tube_height0),
    .tube_spacing0_output    (tube_spacing0),
    .tube_pos1_output        (tube_pos1),
    .tube_height1_output     (tube_height1),
    .tube_spacing1_output    (tube_spacing1),
    .tube_pos2_output        (tube_pos2),
    .tube_height2_output     (tube_height2),
    .tube_spacing2_output    (tube_spacing2),
    .tube_pos3_output        (tube_pos3),
    .tube_height3_output     (tube_height3),
    .tube_spacing3_output    (tube_spacing3),
    .bird_x_output           (bird_x),
    .camera_x_output         (camera_x),
    .p1_bird_y_output        (p1_bird_y),
    .p1_bird_velocity_output (p1_bird_velocity),
    .p1_input_output         (p1_input),
    .bg_xshift_output        (bg_xshift),
    .bird_animation_output   (bird_animation),
    .bird_rotation_output    (bird_rotation)
);

ViewCore#(
    .N_TUBE(N_TUBE),
    .IND_TUBE_INTERACT(IND_TUBE_INTERACT)
) viewcore(
    .clk              (clk),
    .rstn             (rstn),

    .world_seed       (world_seed),
    .game_status      (game_status),
    .score            (score),
    .tube_pos0        (tube_pos0),
    .tube_height0     (tube_height0),
    .tube_spacing0    (tube_spacing0),
    .tube_pos1        (tube_pos1),
    .tube_height1     (tube_height1),
    .tube_spacing1    (tube_spacing1),
    .tube_pos2        (tube_pos2),
    .tube_height2     (tube_height2),
    .tube_spacing2    (tube_spacing2),
    .tube_pos3        (tube_pos3),
    .tube_height3     (tube_height3),
    .tube_spacing3    (tube_spacing3),
    .camera_x         (camera_x),
    .bird_x           (bird_x),
    .p1_bird_y        (p1_bird_y),
    .p1_bird_velocity (p1_bird_velocity),
    .bg_xshift        (bg_xshift),
    .bird_animation   (bird_animation),
    .bird_rotation    (bird_rotation),

    .hs               (VGA_HS),
    .vs               (VGA_VS),
    .rgb              ({ VGA_R, VGA_G, VGA_B })
);

// CalcCore 的测试信号
wire View_CalcCore = SW[0];
wire [15:0] LED_CalcCore;
assign LED_CalcCore[0]    = calc_status == 0;
assign LED_CalcCore[1]    = calc_status == 1;
assign LED_CalcCore[2]    = calc_status == 2;
assign LED_CalcCore[3]    = calc_status == 3;
assign LED_CalcCore[4]    = calc_status == 4;
assign LED_CalcCore[5]    = calc_status == 5;
assign LED_CalcCore[6]    = calc_status == 6;
assign LED_CalcCore[7]    = calc_status == 7;
assign LED_CalcCore[8]    = $unsigned(calc_counter1) < $unsigned(64);
assign LED_CalcCore[11:9] = p1_input;
assign LED_CalcCore[13:12] = 2'b0;
assign LED_CalcCore[15:14] = game_status;

wire View_WorldSeed = SW[1];
wire [15:0] LED_WorldSeed = world_seed;
assign LED = LED_CalcCore & {16{View_CalcCore}}
           | LED_WorldSeed & {16{View_WorldSeed}};

endmodule
