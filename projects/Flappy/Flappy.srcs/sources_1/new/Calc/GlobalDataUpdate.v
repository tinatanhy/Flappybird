module GlobalDataUpdate(
    input clk,
    input rstn,
    input upd,
    input [1:0] game_status,
    input  [31:0] timer,
    input  [31:0] gameover_timestamp,
    output [7:0] shake_x,
    output [7:0] shake_y,
    output finish
);
wire [15:0] hash;
Hash32to16 hash_instance(
    .clk(clk),
    .rstn(rstn),
    .start(upd),
    .seed(timer),
    .finish(finish),
    .hash(hash)
);

wire [31:0] gameover_delta_time = timer - gameover_timestamp;
wire is_shake = game_status == 2'b11 && $signed(gameover_delta_time) >= 0 && $signed(gameover_delta_time) < 8;
assign    shake_x = (hash[10:8] + hash[12:11]) & {8{is_shake}};
assign    shake_y = (hash[2:0]  + hash[4:3]) & {8{is_shake}};

endmodule