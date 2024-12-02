module CntS #(
    parameter               WIDTH               = 16,
    parameter               RST_VLU             = 0
)(
    input                   [ 0 : 0]            clk,
    input                   [ 0 : 0]            rstn,   //复位使能
    input                   [WIDTH-1:0]         d,      //置数
    input                   [ 0 : 0]            ce,     //计数使能信号

    output      reg         [WIDTH-1:0]         q
);
always @(posedge clk) begin
    if (!rstn)
        q <= RST_VLU;
    else if (ce) begin
        if (q == 0)    
            q <= d;
        else
            q <= q - 1;
    end
    else
        q <= q;
end
endmodule