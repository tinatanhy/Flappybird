module AnimFrameCounter#(
    parameter DW = 19,
    parameter FRAME_SIZE = 7500,
    parameter FRAME_N = 40
)(
    input pclk, rstn, ven,
    input  [DW-1:0] imgaddr,
    output [DW-1:0] raddr
);

wire p;
reg [7:0] counter;

PS #(1) ps(
    .s      (~ven),
    .clk    (pclk),
    .p      (p)
);

always @(posedge pclk) begin
    if(~rstn) begin
        counter <= 0;
    end
    else if(p) begin
        if(counter == FRAME_N - 1) begin
            counter <= 0;
        end
        else begin
            counter <= counter + 1;
        end
    end
end

assign raddr = imgaddr + counter * FRAME_SIZE;

endmodule
