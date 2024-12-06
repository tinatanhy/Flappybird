module TubeUpdate(
    input clk,
    input rstn,
    input upd,
    input [12:0] seed,
    input [15:0] score,
    output finish,
    output [31:0]     tube_pos0,
    output [15:0]  tube_height0,
    output [7:0]  tube_spacing0,
    output [31:0]     tube_pos1,
    output [15:0]  tube_height1,
    output [7:0]  tube_spacing1,
    output [31:0]     tube_pos2,
    output [15:0]  tube_height2,
    output [7:0]  tube_spacing2,
    output [31:0]     tube_pos3,
    output [15:0]  tube_height3,
    output [7:0]  tube_spacing3
);
// TODO
// 一个暂时的实现，用于测试。
wire [15:0] hash0, hash1, hash2, hash3;
wire finish0, finish1, finish2, finish3;
Hash32to16 hash32to16_0(
    .clk(clk),
    .rstn(rstn),
    .start(upd),
    .seed({score - 1, 3'b000, seed}),
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
    .seed({score + 1, 3'b000, seed}),
    .finish(finish2),
    .hash(hash2)
);
Hash32to16 hash32to16_3(
    .clk(clk),
    .rstn(rstn),
    .start(upd),
    .seed({score + 2, 3'b000, seed}),
    .finish(finish3),
    .hash(hash3)
);
assign tube_pos0 = score == 0 ? -200 : (score + 1) << 7;
assign tube_pos1 = (score + 2) << 7;
assign tube_pos2 = (score + 3) << 7;
assign tube_pos3 = (score + 4) << 7;
assign tube_spacing0 = 100;
assign tube_spacing1 = 100;
assign tube_spacing2 = 100;
assign tube_spacing3 = 100;
assign tube_height0 = hash0[7:0] + 100;
assign tube_height1 = hash1[7:0] + 100;
assign tube_height2 = hash2[7:0] + 100;
assign tube_height3 = hash3[7:0] + 100;
assign finish = finish0 && finish1 && finish2 && finish3;
endmodule
