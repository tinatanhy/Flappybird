module VGA_tb#(
    parameter DW = 19,
    parameter H_LEN = 100,
    parameter V_LEN = 75
)();
reg clk, rstn, rstn_clk;
initial begin
    clk = 0;
    rstn = 0;
    rstn_clk = 0;
    #10;
    rstn_clk = 1;
    forever #5 clk = ~clk;
end

initial begin
    #100000;
    rstn = 1;
end

wire pclk, locked;

ClkWizPCLK clkwiz_pclk
(
    // Clock out ports
    .clk_out1(pclk),     // output clk_out1
    // Status and control signals
    .resetn(rstn_clk), // input reset
    .locked(locked),       // output locked
    // Clock in ports
    .clk_in1(clk)      // input clk_in1
);

wire hen, ven, hs, vs;
DST dst (
    .rstn(rstn),
    .pclk(pclk),

    .hen(hen),        //水平显示有效
    .ven(ven),        //垂直显示有效
    .hs(hs),         //行同步
    .vs(vs)          //场同步
);

reg [31:0] cnt;
initial begin
    cnt = 0;
end
always @(posedge pclk) begin
    if (!rstn) begin
        cnt <= 0;
    end
    else begin
        if(hen & ven) begin
            cnt <= cnt + 1;
        end
    end
end

wire [31:0] hcnt = cnt % 800;
wire [31:0] vcnt = cnt / 800;

wire [DW-1:0] imgaddr, raddr;
wire [11:0] rdata, rgb;
BRAM_Anim vram_canvas (
  .clka(clk),    
  .ena(1'b0),    
  .wea(1'b0),    
  .addra({DW{1'b0}}), 
  .dina(12'b0),   
  .clkb(clk),   
  .enb(1'b1),     
  .addrb(raddr), 
  .doutb(rdata)  
);
// BRAM_12x32k vram_canvas (
//   .clka(clk),    
//   .ena(1'b0),    
//   .wea(1'b0),    
//   .addra(15'b0), 
//   .dina(12'b0),   
//   .clkb(clk),   
//   .enb(1'b1),     
//   .addrb(raddr), 
//   .doutb(rdata)  
// );
DDP#(
    .DW(DW),
    .H_LEN(H_LEN),
    .V_LEN(V_LEN)
) ddp(
    .hen(hen),
    .ven(ven),
    .rstn(rstn),
    .pclk(pclk),
    .rdata(rdata),
    .rgb(rgb),
    .raddr(imgaddr)
);
AnimFrameCounter#(
    .DW(DW),
    .FRAME_SIZE(7500),
    .FRAME_N(40)
) framecounter (
    .pclk(pclk), 
    .rstn(rstn), 
    .ven(ven),
    .imgaddr(imgaddr),
    .raddr(raddr)
);
endmodule
