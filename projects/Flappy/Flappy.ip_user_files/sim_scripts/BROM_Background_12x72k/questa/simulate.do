onbreak {quit -f}
onerror {quit -f}

vsim  -lib xil_defaultlib BROM_Background_12x72k_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {BROM_Background_12x72k.udo}

run 1000ns

quit -force
