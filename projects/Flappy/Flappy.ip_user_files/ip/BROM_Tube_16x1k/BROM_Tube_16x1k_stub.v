// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
// Date        : Sat Dec  7 00:17:57 2024
// Host        : tina running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               d:/fpgaflappy/projects/Flappy/Flappy.gen/sources_1/ip/BROM_Tube_16x1k/BROM_Tube_16x1k_stub.v
// Design      : BROM_Tube_16x1k
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_6,Vivado 2023.1" *)
module BROM_Tube_16x1k(clka, addra, douta)
/* synthesis syn_black_box black_box_pad_pin="addra[9:0],douta[15:0]" */
/* synthesis syn_force_seq_prim="clka" */;
  input clka /* synthesis syn_isclock = 1 */;
  input [9:0]addra;
  output [15:0]douta;
endmodule
