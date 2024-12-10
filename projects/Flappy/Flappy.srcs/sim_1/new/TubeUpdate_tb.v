
module TubeUpdate_tb();

reg clk;
reg rstn;
reg upd;
reg [12:0] seed;
reg [15:0] score;
wire finish;
wire [15:0]  debug_status;
wire [31:0]     tube_pos0;
wire [15:0]  tube_height0;
wire [7:0]  tube_spacing0;
wire [31:0]     tube_pos1;
wire [15:0]  tube_height1;
wire [7:0]  tube_spacing1;
wire [31:0]     tube_pos2;
wire [15:0]  tube_height2;
wire [7:0]  tube_spacing2;
wire [31:0]     tube_pos3;
wire [15:0]  tube_height3;
wire [7:0]  tube_spacing3;

initial begin  
    clk = 0;  
    forever #5 clk = ~clk;  // 10 ns 时钟周期  
end  

// 初始化信号  
initial begin  
    // 初始化所有信号  
    rstn = 0;  
    score = 0;
    upd = 0;
    seed = 32'hdeadbeef;  

    // 进行复位  
    #10 rstn = 1;  // 释放复位  
    #10;  

    forever begin
        #100;
        score = score + 1;
        upd = 1;
        #10;
        upd = 0;
    end

    $finish;  
end  

TubeUpdate tubeupdate(
.clk          (clk),         
.rstn         (rstn),
.upd          (upd),
.seed         (seed),
.score        (score),
.finish       (finish),
.debug_status (debug_status),
.tube_pos0    (tube_pos0),
.tube_height0 (tube_height0),
.tube_spacing0(tube_spacing0),
.tube_pos1    (tube_pos1),
.tube_height1 (tube_height1),
.tube_spacing1(tube_spacing1),
.tube_pos2    (tube_pos2),
.tube_height2 (tube_height2),
.tube_spacing2(tube_spacing2),
.tube_pos3    (tube_pos3),
.tube_height3 (tube_height3),
.tube_spacing3(tube_spacing3)
);
endmodule
