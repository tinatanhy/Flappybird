// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
// Date        : Fri Dec 27 18:06:36 2024
// Host        : RUBATOPC-LITE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/rubatotree/Repositories/Flappybird/projects/Flappy/Flappy.gen/sources_1/ip/BROM_Numbers_16x3k/BROM_Numbers_16x3k_stub.v
// Design      : BROM_Numbers_16x3k
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_6,Vivado 2023.1" *)
module BROM_Numbers_16x3k(clka, addra, douta)
/* synthesis syn_black_box black_box_pad_pin="addra[11:0],douta[15:0]" */
/* synthesis syn_force_seq_prim="clka" */;
  input clka /* synthesis syn_isclock = 1 */;
  input [11:0]addra;
  output [15:0]douta;
endmodule
