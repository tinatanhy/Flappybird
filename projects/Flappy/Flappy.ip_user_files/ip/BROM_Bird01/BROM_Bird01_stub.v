// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
// Date        : Thu Dec 12 21:10:59 2024
// Host        : rubatoPC running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top BROM_Bird01 -prefix
//               BROM_Bird01_ BROM_Bird01_stub.v
// Design      : BROM_Bird01
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_6,Vivado 2023.1" *)
module BROM_Bird01(clka, addra, douta)
/* synthesis syn_black_box black_box_pad_pin="addra[15:0],douta[15:0]" */
/* synthesis syn_force_seq_prim="clka" */;
  input clka /* synthesis syn_isclock = 1 */;
  input [15:0]addra;
  output [15:0]douta;
endmodule
