transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+BROM_Numbers_16x3k  -L xpm -L blk_mem_gen_v8_4_6 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.BROM_Numbers_16x3k xil_defaultlib.glbl

do {BROM_Numbers_16x3k.udo}

run 1000ns

endsim

quit -force
