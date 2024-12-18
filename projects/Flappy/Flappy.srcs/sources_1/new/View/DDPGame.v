module DDPGame#(
        parameter H_LEN = 800,
        parameter V_LEN = 600
)(
    input               hen,
    input               ven,
    input               rstn,
    input               pclk,
    input  [11:0]       rdata,

    output reg [11:0]   rgb,
    output reg [10:0]   pixel_x, pixel_y
);

wire p;
PS #(1) ps(
    .s      (~(hen&ven)),
    .clk    (pclk),
    .rstn(rstn),
    .p      (p)
);

always @(posedge pclk) begin            //可能慢一个周期，改hen,ven即可
    if(!rstn) begin
        rgb   <= 12'b0;
        pixel_x <= 0;
        pixel_y <= 0;
    end 
    else if(hen && ven) begin
        rgb <= rdata;
        pixel_x <= pixel_x + 1;
    end                             
    else if(p) begin                
        rgb <= 0;
        pixel_x <= 0;
        if(pixel_y == V_LEN - 1) begin
            pixel_y = 0;
        end
        else begin
            pixel_y <= pixel_y + 1;
        end
    end
    else rgb <= 0;
end

endmodule