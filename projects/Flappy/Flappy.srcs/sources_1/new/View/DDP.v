//实现DDP功能，将画布与显示屏适配，从而产生色彩信息。
//DDP和DST共同称为DU即显示单元
module DDP#(
        parameter DW = 19,
        parameter H_LEN = 100,
        parameter V_LEN = 75
)(
    input               hen,
    input               ven,
    input               rstn,
    input               pclk,
    input  [11:0]       rdata,

    output reg [11:0]   rgb,
    output reg [DW-1:0] raddr
);
localparam SCALE = $clog2(800 / H_LEN);
reg [SCALE-1:0] sx;       //放大四倍
reg [SCALE-1:0] sy;
reg [SCALE-1:0] nsx;
reg [SCALE-1:0] nsy;


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
        nsx   <= {SCALE{1'b0}}; 
        nsy   <= {SCALE{1'b1}};
        rgb   <= 12'b0;
        raddr <= 0;
    end 
    else if(hen && ven) begin
        rgb <= rdata;
        if(&sx) begin
            raddr <= raddr + 1;
        end
        nsx <= sx + 1;
    end                                //无效区域
    else if(p) begin                   //ven下降沿
        rgb <= 0;
        if(~(&sy)) begin
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