onbreak {quit -f}
onerror {quit -f}

vsim  -lib xil_defaultlib BROM_Tube_16x4k_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {BROM_Tube_16x4k.udo}

run 1000ns

quit -force
