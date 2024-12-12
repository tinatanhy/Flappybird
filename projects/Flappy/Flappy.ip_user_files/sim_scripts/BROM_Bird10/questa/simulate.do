onbreak {quit -f}
onerror {quit -f}

vsim  -lib xil_defaultlib BROM_Bird10_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {BROM_Bird10.udo}

run 1000ns

quit -force
