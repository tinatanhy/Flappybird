module Top(
    input CLK100MHZ, CPU_RESETN, BTNC,
    output VGA_HS, VGA_VS,
    output [2:0] LED,
    output [3:0] VGA_R, VGA_G, VGA_B
);
parameter N_TUBE = 4;
parameter IND_TUBE_INTERACT = 1;
wire clk = CLK100MHZ;
wire rstn = CPU_RESETN;
wire btn = BTNC;
wire wdata_finish;
wire [15:0] world_seed;

wire CLK72HZ;
FrameClock time72hz(
    .clk        (clk),
    .rstn       (rstn),
    .clk_out    (CLK72HZ)
);

WorldData worlddata(
    .clk        (clk),
    .rstn       (rstn),
    .upd        (upd),
    .finish     (wdata_finish),
    .world_seed (world_seed)
);

CalcCore#(
    .N_TUBE(N_TUBE),
    .IND_TUBE_INTERACT(IND_TUBE_INTERACT)
) calccore(
    .clk        (clk),
    .rstn       (rstn),
    .btn        (btn),
    .upd        (CLK72HZ),
    .world_seed (world_seed),
    .finish     (finish)
);

ViewCore#(
    .N_TUBE(N_TUBE),
    .IND_TUBE_INTERACT(IND_TUBE_INTERACT)
) viewcore(
    .clk (clk),
    .rstn(rstn),
    .hs  (VGA_HS),
    .vs  (VGA_VS),
    .rgb ({ VGA_R, VGA_G, VGA_B })
);

wire pressed;         
wire check;         
wire released;        
Button button_inst (  
    .clk        (CLK72HZ),  
    .btn        (BTNC),  
    .pressed    (pressed),  
    .check      (check),  
    .released   (released)  
);  
assign LED[0] = check;  
assign LED[1] = released;  
assign LED[2] = pressed;  

endmodule
