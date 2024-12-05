module WorldData(
    input clk,
    input rstn,
    input upd,
    output finish,          
    output [15:0] world_seed    
);
// RNG16 的简单封装。
RNG16 rng16(
    .clk(clk),
    .rstn(rstn),
    .upd(upd),
    .finish(finish),
    .rand16(world_seed)
);
endmodule