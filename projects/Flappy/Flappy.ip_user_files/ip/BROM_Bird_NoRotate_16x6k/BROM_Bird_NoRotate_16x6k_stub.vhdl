-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
-- Date        : Thu Dec  5 19:13:49 2024
-- Host        : rubatoPC running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub -rename_top BROM_Bird_NoRotate_16x6k -prefix
--               BROM_Bird_NoRotate_16x6k_ BROM_Bird_NoRotate_16x6k_stub.vhdl
-- Design      : BROM_Bird_NoRotate_16x6k
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BROM_Bird_NoRotate_16x6k is
  Port ( 
    clka : in STD_LOGIC;
    addra : in STD_LOGIC_VECTOR ( 12 downto 0 );
    douta : out STD_LOGIC_VECTOR ( 15 downto 0 )
  );

end BROM_Bird_NoRotate_16x6k;

architecture stub of BROM_Bird_NoRotate_16x6k is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clka,addra[12:0],douta[15:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "blk_mem_gen_v8_4_6,Vivado 2023.1";
begin
end;
