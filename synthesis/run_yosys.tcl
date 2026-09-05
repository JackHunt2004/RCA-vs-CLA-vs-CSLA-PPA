# Generic Yosys synthesis flow
# Sky130 HD TT 0.25C 1.80V

read_verilog -Irtl $::env(RTL_SOURCES)

hierarchy -top $::env(TOP_MODULE)

proc
memory
opt

techmap
opt

dfflibmap -liberty $::env(SKY130_LIB)
abc -liberty $::env(SKY130_LIB)

opt

stat -liberty $::env(SKY130_LIB)

check

write_verilog -noattr $::env(NETLIST_OUT)
