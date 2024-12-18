module KeyInput (  
    input upd, 
    input btn, 
    input rstn,
    output pressed, check, released, finish
); 
// 已完成
// Button 模块的简单封装。
// 为什么要这样做呢.jpg
Button button(
    .clk(upd),
    .btn(btn),
    .rstn(rstn),
    .check(check),
    .pressed(pressed),
    .released(released)
);
assign finish = 1'b1;
endmodule