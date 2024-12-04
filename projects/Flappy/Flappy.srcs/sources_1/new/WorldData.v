module WorldData(
    input clk,
    input rstn,
    output finish,          
    output [15:0] world_seed    
);
// RNG16 的简单封装。
RNG16 rng16(
    .clk(clk),
    .rstn(rstn),
    .finish(finish),
    .rand16(world_seed)
);
endmodule