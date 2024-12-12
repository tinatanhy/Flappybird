module TubeUpdate(
    input clk,
    input rstn,
    input upd,
    input [12:0] seed,
    input [15:0] score,
    input [31:0] bird_start_x,
    output finish,
    output [15:0]  debug_status,
    output reg [31:0]     tube_pos0,
    output reg [15:0]  tube_height0,
    output reg [7:0]  tube_spacing0,
    output reg [31:0]     tube_pos1,
    output reg [15:0]  tube_height1,
    output reg [7:0]  tube_spacing1,
    output reg [31:0]     tube_pos2,
    output reg [15:0]  tube_height2,
    output reg [7:0]  tube_spacing2,
    output reg [31:0]     tube_pos3,
    output reg [15:0]  tube_height3,
    output reg [7:0]  tube_spacing3
);
wire [31:0]     tube_pos0_calc;
wire [15:0]  tube_height0_calc;
wire [7:0]  tube_spacing0_calc;
wire [31:0]     tube_pos1_calc;
wire [15:0]  tube_height1_calc;
wire [7:0]  tube_spacing1_calc;
wire [31:0]     tube_pos2_calc;
wire [15:0]  tube_height2_calc;
wire [7:0]  tube_spacing2_calc;
wire [31:0]     tube_pos3_calc;
wire [15:0]  tube_height3_calc;
wire [7:0]  tube_spacing3_calc;

wire [15:0] hash0, hash1, hash2, hash3;
wire finish0, finish1, finish2, finish3;
Hash32to16 hash32to16_0(
    .clk(clk),
    .rstn(rstn),
    .start(upd),
    .seed({score - 16'd1, 3'b000, seed}),
    .finish(finish0),
    .hash(hash0)
);
Hash32to16 hash32to16_1(
    .clk(clk),
    .rstn(rstn),
    .start(upd),
    .seed({score, 3'b000, seed}),
    .finish(finish1),
    .hash(hash1)
);
Hash32to16 hash32to16_2(
    .clk(clk),
    .rstn(rstn),
    .start(upd),
    .seed({score + 16'd1, 3'b000, seed}),
    .finish(finish2),
    .hash(hash2)
);
Hash32to16 hash32to16_3(
    .clk(clk),
    .rstn(rstn),
    .start(upd),
    .seed({score + 16'd2, 3'b000, seed}),
    .finish(finish3),
    .hash(hash3)
);
assign tube_pos0_calc = bird_start_x + ((score == 0) ? -200 : 
                                       (((score + 1) << 7) + ((score + 1) << 6)));
assign tube_pos1_calc = bird_start_x + (((score + 2) << 7) + ((score + 2) << 6));
assign tube_pos2_calc = bird_start_x + (((score + 3) << 7) + ((score + 3) << 6));
assign tube_pos3_calc = bird_start_x + (((score + 4) << 7) + ((score + 4) << 6));
assign tube_spacing0_calc = 120;
assign tube_spacing1_calc = 120;
assign tube_spacing2_calc = 120;
assign tube_spacing3_calc = 120;
assign tube_height0_calc = hash0[10:4] + hash0[15:11] + 44;
assign tube_height1_calc = hash1[10:4] + hash1[15:11] + 44;
assign tube_height2_calc = hash2[10:4] + hash2[15:11] + 44;
assign tube_height3_calc = hash3[10:4] + hash3[15:11] + 44;
assign finish = finish0 & finish1 & finish2 & finish3;
assign debug_status = { 10'b1111111111, rstn, upd, finish3, finish2, finish1, finish0 };
reg lock;
initial begin
    lock <= 1;
end
always @(posedge clk) begin
    if(~rstn || (finish && !upd && !lock)) begin // 玄学
            tube_pos0 <=     tube_pos0_calc;
         tube_height0 <=  tube_height0_calc;
        tube_spacing0 <= tube_spacing0_calc;
            tube_pos1 <=     tube_pos1_calc;
         tube_height1 <=  tube_height1_calc;
        tube_spacing1 <= tube_spacing1_calc;
            tube_pos2 <=     tube_pos2_calc;
         tube_height2 <=  tube_height2_calc;
        tube_spacing2 <= tube_spacing2_calc;
            tube_pos3 <=     tube_pos3_calc;
         tube_height3 <=  tube_height3_calc;
        tube_spacing3 <= tube_spacing3_calc;
        lock <= 1;
    end
    else if(upd) begin
        lock <= 0;
    end
end
endmodule
