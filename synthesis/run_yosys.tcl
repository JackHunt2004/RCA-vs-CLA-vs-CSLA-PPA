# Generic Yosys synthesis flow
# Sky130 HD TT 0.25C 1.80V

read_verilog -Irtl __RTL_SOURCES__

hierarchy -top __TOP_MODULE__

proc
memory
opt

techmap
opt

dfflibmap -liberty __SKY130_LIB__
abc -liberty __SKY130_LIB__

opt

stat -liberty __SKY130_LIB__

check

write_verilog -noattr __NETLIST_OUT__
