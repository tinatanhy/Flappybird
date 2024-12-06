transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+ClkWizPCLK  -L xpm -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.ClkWizPCLK xil_defaultlib.glbl

do {ClkWizPCLK.udo}

run 1000ns

endsim

quit -force
