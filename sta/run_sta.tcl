# Generic OpenSTA timing analysis
# Sky130 HD TT 0.25C 1.80V

read_liberty $::env(SKY130_LIB)

read_verilog $::env(NETLIST_IN)

link_design $::env(TOP_MODULE)

read_sdc $::env(SDC_FILE)

report_checks -path_delay max -fields {slew cap input_pins} -digits 3
report_checks -path_delay min -fields {slew cap input_pins} -digits 3

report_worst_slack -max -digits 3
report_worst_slack -min -digits 3

report_clock_skew -digits 3
