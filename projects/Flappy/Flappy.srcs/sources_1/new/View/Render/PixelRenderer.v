module PixelRenderer(
    input clk,
    input rstn,
    input [10:0] pixel_x,
    input [10:0] pixel_y,
    output [11:0] rgb
);
assign rgb = {pixel_x[3:0], pixel_y[3:0], 4'b1};
endmodule