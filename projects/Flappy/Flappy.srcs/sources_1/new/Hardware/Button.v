module Button (  
    input wire clk,       // 输入时钟  
    input wire rstn,
    input wire btn,       // 任意按钮型信号
    output pressed, check, released
);  

reg btn_r1, btn_r2;
always @(posedge clk) begin          
    if(~rstn) begin
        btn_r1 <= 1'b0;
        btn_r2 <= 1'b0;
    end else begin
        btn_r1 <= btn;  
        btn_r2 <= btn_r1;
    end
end   

assign check    =  btn_r1;
assign pressed  =  btn_r1 & ~btn_r2;
assign released = ~btn_r1 &  btn_r2;
endmodule