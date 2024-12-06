onbreak {quit -f}
onerror {quit -f}

vsim  -lib xil_defaultlib BROM_Numbers_16x3k_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {BROM_Numbers_16x3k.udo}

run 1000ns

quit -force
