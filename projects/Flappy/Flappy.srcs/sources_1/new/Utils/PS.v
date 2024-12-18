module PS#(
	parameter  WIDTH = 1
) (
	input             s,
	input             clk,
    input             rstn,
	output            p
);

reg sig_r1, sig_r2;

always @(posedge clk) begin
    if(~rstn) begin
        sig_r1 <= 1'b0;
        sig_r2 <= 1'b0;
    end else begin
        sig_r1 <= s;
        sig_r2 <= sig_r1;
    end
end

assign p = sig_r1 & ~sig_r2;
endmodule