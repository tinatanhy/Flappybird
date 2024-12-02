//实现DDP功能，将画布与显示屏适配，从而产生色彩信息。
//DDP和DST共同称为DU即显示单元
module DDP#(
        parameter DW = 15,
        parameter H_LEN = 200,
        parameter V_LEN = 150
)(
    input               hen,
    input               ven,
    input               rstn,
    input               pclk,
    input  [11:0]       rdata,

    output reg [11:0]   rgb,
    output reg [DW-1:0] raddr
);

reg [1:0] sx;       //放大四倍
reg [1:0] sy;
reg [1:0] nsx;
reg [1:0] nsy;


always @(*) begin
    sx = nsx;
    sy = nsy;
end

wire p;

PS #(1) ps(                             //取ven下降沿
    .s      (~(hen&ven)),
    .clk    (pclk),
    .p      (p)
);

always @(posedge pclk) begin            //可能慢一个周期，改hen,ven即可
    if(!rstn) begin
        nsx   <= 0; 
        nsy   <= 3;
        rgb   <= 12'b0;
        raddr <= 0;
    end 
    else if(hen && ven) begin
        rgb <= rdata;
        if(sx == 2'b11) begin
            raddr <= raddr + 1;
        end
        nsx <= sx + 1;
    end                                //无效区域
    else if(p) begin                   //ven下降沿
        rgb <= 0;
        if(sy != 2'b11) begin
            raddr <= raddr - H_LEN;
        end
        else if(raddr == H_LEN * V_LEN) begin
            raddr <= 0;
        end
        nsy <= sy + 1;
    end
    else rgb <= 0;
end

endmodule