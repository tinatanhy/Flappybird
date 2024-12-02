## CLOCK
set_property -dict { PACKAGE_PIN V18  IOSTANDARD LVCMOS33 } [get_ports {clk}]
## BUTTON
set_property -dict {PACKAGE_PIN F20 IOSTANDARD LVCMOS33} [get_ports { rst }]

## SEG DATA 
set_property -dict { PACKAGE_PIN F18   IOSTANDARD LVCMOS33 } [get_ports {out[0]}]
set_property -dict { PACKAGE_PIN E18   IOSTANDARD LVCMOS33 } [get_ports {out[1]}]
set_property -dict { PACKAGE_PIN B20   IOSTANDARD LVCMOS33 } [get_ports {out[2]}]
set_property -dict { PACKAGE_PIN A20   IOSTANDARD LVCMOS33 } [get_ports {out[3]}]

## SEG AN
set_property -dict { PACKAGE_PIN A18   IOSTANDARD LVCMOS33 } [get_ports {select[0]}]
set_property -dict { PACKAGE_PIN A19   IOSTANDARD LVCMOS33 } [get_ports {select[1]}]
set_property -dict { PACKAGE_PIN F19   IOSTANDARD LVCMOS33 } [get_ports {select[2]}]