module UPDPS(
	input             s,
	input             clk,
	input             upd,
    input             rstn,
	output            p
);

wire p_upd;
reg sig_r1, sig_r2;

PS #(1) ps(
    .s      (upd),
    .clk    (clk),
    .rstn   (rstn),
    .p      (p_upd)
);

always @(posedge clk) begin
    if(~rstn) begin
        sig_r1 <= 1'b0;
        sig_r2 <= 1'b0;
    end else begin
        if(p_upd) begin
            sig_r1 <= s;
            sig_r2 <= sig_r1;
        end
    end
end

assign p = sig_r1 & ~sig_r2;
endmodule