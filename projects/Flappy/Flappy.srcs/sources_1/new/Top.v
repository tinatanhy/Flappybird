module Top(
    input CLK100MHZ, CPU_RESETN, BTNC, BTNU, BTND, BTNL, BTNR,
    input [15:0] SW,
    output VGA_HS, VGA_VS,
    output [15:0] LED,
    output [3:0] VGA_R, VGA_G, VGA_B,
    output  [7:0]       AN,            
    output  [6:0]       seg_data      
);
parameter N_TUBE = 4;
parameter IND_TUBE_INTERACT = 1;
wire clk = CLK100MHZ;
wire rstn = CPU_RESETN;
wire btn = BTNC;
wire wdata_finish, calc_finish;
wire [2:0] calc_status;
wire [15:0]     calc_debug_led;
wire [15:0]     view_debug_led;
wire [31:0]     calc_debug_seg;
wire [31:0]     view_debug_seg;
wire [31:0]            timer;
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
wire retry_pressed, retry_pressed_posedge;
wire retry_status, retry_status_posedge;
assign retry_status = game_status == 2'b00;
Button button_retry(
    .clk(upd),
    .btn(BTNU),
    .pressed(retry_pressed)
);
PS retry_btn_ps(
    .clk(upd),
    .s(retry_pressed),
    .p(retry_pressed_posedge)
);
PS retry_status_ps(
    .clk(upd),
    .s(retry_status),
    .p(retry_status_posedge)
);
wire retry_upd = retry_pressed_posedge || retry_status_posedge;
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
    .retry                   (retry_pressed),

    .finish                  (calc_finish),
    .calc_status             (calc_status),
    .calc_debug_led          (calc_debug_led),
    .calc_debug_seg          (calc_debug_seg),

    .timer_output            (timer),
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

    .view_debug_led      (view_debug_led),
    .view_debug_seg      (view_debug_seg),
    .timer_in            (timer),
    .world_seed_in       (world_seed),
    .game_status_in      (game_status),
    .score_in            (score),
    .tube_pos0_in        (tube_pos0),
    .tube_height0_in     (tube_height0),
    .tube_spacing0_in    (tube_spacing0),
    .tube_pos1_in        (tube_pos1),
    .tube_height1_in     (tube_height1),
    .tube_spacing1_in    (tube_spacing1),
    .tube_pos2_in        (tube_pos2),
    .tube_height2_in     (tube_height2),
    .tube_spacing2_in    (tube_spacing2),
    .tube_pos3_in        (tube_pos3),
    .tube_height3_in     (tube_height3),
    .tube_spacing3_in    (tube_spacing3),
    .camera_x_in         (camera_x),
    .bird_x_in           (bird_x),
    .p1_bird_y_in        (p1_bird_y),
    .p1_bird_velocity_in (p1_bird_velocity),
    .bg_xshift_in        (bg_xshift),
    .bird_animation_in   (bird_animation),
    .bird_rotation_in    (bird_rotation),

    .hs               (VGA_HS),
    .vs               (VGA_VS),
    .rgb              ({ VGA_R, VGA_G, VGA_B })
);

reg [15:0] LEDData;
reg [31:0] SegData;
reg [7:0] SegMask;
initial begin
    LEDData = 16'h0000;
    SegData = 32'h00000000;
    SegMask = 8'b00000000;
end

always @(*) begin
    LEDData = 16'h0000;
    SegData = 32'h00000000;
    SegMask = 8'b00000000;
    case(SW)
    16'b0000_0000_0000_0001: begin
        // CalcCore Data
        LEDData[0]    = calc_status == 0;
        LEDData[1]    = calc_status == 1;
        LEDData[2]    = calc_status == 2;
        LEDData[3]    = calc_status == 3;
        LEDData[4]    = calc_status == 4;
        LEDData[5]    = calc_status == 5;
        LEDData[6]    = calc_status == 6;
        LEDData[7]    = calc_status == 7;
        LEDData[8]    = $unsigned(timer[6:0]) < $unsigned(64);
        LEDData[11:9] = p1_input;
        LEDData[13:12] = 2'b0;
        LEDData[15:14] = game_status;
        SegData[31:28] = (p1_bird_y[31:16] / 1000) % 10;
        SegData[27:24] = (p1_bird_y[31:16] / 100) % 10;
        SegData[23:20] = (p1_bird_y[31:16] / 10) % 10;
        SegData[19:16] = (p1_bird_y[31:16]) % 10;
        SegData[15:12] = (score / 1000) % 10;
        SegData[11: 8] = (score / 100) % 10;
        SegData[ 7: 4] = (score / 10) % 10;
        SegData[ 3: 0] = (score) % 10;
        SegMask = 8'b1111_1111;
    end
    16'b0000_0000_0000_0010: begin
        LEDData = world_seed;
        SegData = {32'b0, world_seed};
        SegMask = 8'b0000_1111;
    end
    16'b0000_0000_0000_0100: begin
        LEDData = timer[15:0];
        SegData = timer;
        SegMask = 8'b1111_1111;
    end
    16'b0000_0000_0000_1000: begin
        LEDData = score;
        SegData[31:28] = (bird_x / 10000) % 10;
        SegData[27:24] = (bird_x / 1000) % 10;
        SegData[23:20] = (bird_x / 100) % 10;
        SegData[19:16] = (bird_x / 10) % 10;
        SegData[15:12] = ((tube_pos1 + 50) / 10000) % 10;
        SegData[11: 8] = ((tube_pos1 + 50) / 1000) % 10;
        SegData[ 7: 4] = ((tube_pos1 + 50) / 100) % 10;
        SegData[ 3: 0] = ((tube_pos1 + 50) / 10) % 10;
        SegMask = 8'b1111_1111;
    end
    16'b0000_0000_0001_0000: begin
        LEDData = score;
        SegData[15:12] = ((tube_height1) / 1000) % 10;
        SegData[11: 8] = ((tube_height1) / 100) % 10;
        SegData[ 7: 4] = ((tube_height1) / 10) % 10;
        SegData[ 3: 0] = ((tube_height1)) % 10;
        SegData[15:12] = ((tube_pos1) / 10000) % 10;
        SegData[11: 8] = ((tube_pos1) / 1000) % 10;
        SegData[ 7: 4] = ((tube_pos1) / 100) % 10;
        SegData[ 3: 0] = ((tube_pos1) / 10) % 10;
        SegMask = 8'b1111_1111;
    end
    16'b0000_0000_0000_0011: begin
        LEDData[0]    = calc_status == 0;
        LEDData[1]    = calc_status == 1;
        LEDData[2]    = calc_status == 2;
        LEDData[3]    = calc_status == 3;
        LEDData[4]    = calc_status == 4;
        LEDData[5]    = calc_status == 5;
        LEDData[6]    = calc_status == 6;
        LEDData[7]    = calc_status == 7;
        LEDData[8]    = $unsigned(timer[6:0]) < $unsigned(64);
        LEDData[11:9] = p1_input;
        LEDData[13:12] = 2'b0;
        LEDData[15:14] = game_status;
        SegData[31:28] = (p1_bird_y[31:16] / 1000) % 10;
        SegData[27:24] = (p1_bird_y[31:16] / 100) % 10;
        SegData[23:20] = (p1_bird_y[31:16] / 10) % 10;
        SegData[19:16] = (p1_bird_y[31:16]) % 10;
        SegData[15:12] = (p1_bird_velocity[31:16] / 1000) % 10;
        SegData[11: 8] = (p1_bird_velocity[31:16] / 100) % 10;
        SegData[ 7: 4] = (p1_bird_velocity[31:16] / 10) % 10;
        SegData[ 3: 0] = (p1_bird_velocity[31:16]) % 10;
        SegMask = 8'b1111_1111;
    end
    endcase
    
end

assign LED = LEDData;

SegWithMask SegWithMaskInst(  
    .clk(CLK100MHZ),  
    .rst(~rstn),  
    .output_data(SegData),    
    .output_valid(SegMask),  
    .seg_data(seg_data),  
    .seg_an(AN)  
);  
endmodule
