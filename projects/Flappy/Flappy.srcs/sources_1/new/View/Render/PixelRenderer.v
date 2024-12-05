module PixelRenderer(
    input clk,
    input rstn,
    input [10:0] pixel_x,
    input [10:0] pixel_y,
    input [31:0] timer,
    output [11:0] rgb
);
assign rgb = (pixel_x >= 256 && pixel_x <= 543 && pixel_y >= 44 && pixel_y <= 555) ? 12'b1 : 12'b0;
endmodule