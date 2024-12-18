module BROMAccess (
    input clk,
    input pclk,
    input rstn,
    input   [16:0]  addr_bg,
    input   [9:0]   addr_land,
    input   [9:0]   addr_tube,
    input   [15:0]  addr_bird,
    input   [13:0]  addr_ui,
    input   [11:0]  addr_score,
    output reg [11:0]  col_bg,
    output reg [11:0]  col_land0,
    output reg [15:0]  col_tube_0,
    output reg [15:0]  col_bird00,
    output reg [15:0]  col_bird01,
    output reg [15:0]  col_bird02,
    output reg [15:0]  col_ui,
    output reg [15:0]  col_score
);

reg   [16:0]  in_addr_bg;
reg   [9:0]   in_addr_land;
reg   [9:0]   in_addr_tube;
reg   [15:0]  in_addr_bird;
reg   [13:0]  in_addr_ui;
reg   [11:0]  in_addr_score;
wire  [11:0]  out_col_bg;
wire  [11:0]  out_col_land0;
wire  [15:0]  out_col_tube_0;
wire  [15:0]  out_col_bird00;
wire  [15:0]  out_col_bird01;
wire  [15:0]  out_col_bird02;
wire  [15:0]  out_col_ui;
wire  [15:0]  out_col_score;

always @(posedge pclk) begin
    if(~rstn) begin
        in_addr_bg <= 0;
        in_addr_land <= 0;
        in_addr_tube <= 0;
        in_addr_bird <= 0;
        in_addr_ui <= 0;
        in_addr_score <= 0;
        col_bg <= 0;
        col_land0 <= 0;
        col_tube_0 <= 0;
        col_bird00 <= 0;
        col_bird01 <= 0;
        col_bird02 <= 0;
        col_ui <= 0;
        col_score <= 0;
    end else begin
        in_addr_bg <= addr_bg;
        in_addr_land <= addr_land;
        in_addr_tube <= addr_tube;
        in_addr_bird <= addr_bird;
        in_addr_ui <= addr_ui;
        in_addr_score <= addr_score;
        col_bg <= out_col_bg;
        col_land0 <= out_col_land0;
        col_tube_0 <= out_col_tube_0;
        col_bird00 <= out_col_bird00;
        col_bird01 <= out_col_bird01;
        col_bird02 <= out_col_bird02;
        col_ui <= out_col_ui;
        col_score <= out_col_score;
    end
end

BROM_Background_12x72k brom_bg (
  .clka(clk),          
  .addra(in_addr_bg),  
  .douta(out_col_bg)   
);

BROM_Land_12x1k brom_land (
  .clka(clk),           
  .addra(in_addr_land), 
  .douta(out_col_land0) 
);

BROM_Tube_16x1k brom_tube (
  .clka(clk),
  .addra(in_addr_tube),
  .douta(out_col_tube_0)
);

BROM_Bird00 brom_bird00 (
  .clka(clk),         
  .addra(in_addr_bird),  
  .douta(out_col_bird00)  
);
BROM_Bird01 brom_bird01 (
  .clka(clk),         
  .addra(in_addr_bird),  
  .douta(out_col_bird01)  
);
BROM_Bird02 brom_bird02 (
  .clka(clk),         
  .addra(in_addr_bird),  
  .douta(out_col_bird02)  
);

BROM_CompTexture_16x9k brom_comptex (
    .clka(clk),    // input wire clka
    .addra(in_addr_ui),  
    .douta(out_col_ui)  // output wire [15 : 0] douta
);

BROM_Numbers_16x3k brom_score (
    .clka(clk),    // input wire clka
    .addra(in_addr_score),  // input wire [11 : 0] addra
    .douta(out_col_score)  // output wire [15 : 0] douta
);
endmodule
