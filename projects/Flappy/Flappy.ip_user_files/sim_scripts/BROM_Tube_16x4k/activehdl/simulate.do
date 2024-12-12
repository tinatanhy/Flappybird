transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+BROM_Tube_16x4k  -L xpm -L blk_mem_gen_v8_4_6 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.BROM_Tube_16x4k xil_defaultlib.glbl

do {BROM_Tube_16x4k.udo}

run 1000ns

endsim

quit -force
