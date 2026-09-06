# Generic OpenSTA power analysis
# Sky130 HD TT 0.25C 1.80V

read_liberty $::env(SKY130_LIB)

read_verilog $::env(NETLIST_IN)

link_design $::env(TOP_MODULE)

read_sdc $::env(SDC_FILE)

read_vcd -scope $::env(VCD_SCOPE) \
         -begin_time $::env(POWER_BEGIN_PS) \
         -end_time $::env(POWER_END_PS) \
         $::env(VCD_IN)

report_power -digits 3
