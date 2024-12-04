module PS#(
	parameter  WIDTH = 1
) (
	input             s,
	input             clk,
	output            p
);

// 二级寄存器。可能存在时序问题，从而要使用三级寄存器？
reg sig_r1, sig_r2;
initial begin
    sig_r1 = 1'b0;
    sig_r2 = 1'b0;
end

always @(posedge clk) begin
    sig_r1 <= s;
    sig_r2 <= sig_r1;
end

assign p = sig_r1 & ~sig_r2;
endmodule