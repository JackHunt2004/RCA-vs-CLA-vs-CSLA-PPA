#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

ARCH="${1:-}"
WORKLOAD="${2:-}"

case "$ARCH" in
    rca)
        TOP_MODULE="rca_32"
        NETLIST_IN="$RESULTS_DIR/area/rca_32_synth.v"
        VCD_SCOPE="rca_gate_tb/dut"
        ;;
    cla)
        TOP_MODULE="cla_32"
        NETLIST_IN="$RESULTS_DIR/area/cla_32_synth.v"
        VCD_SCOPE="cla_gate_tb/dut"
        ;;
    csla)
        TOP_MODULE="csla_32"
        NETLIST_IN="$RESULTS_DIR/area/csla_32_synth.v"
        VCD_SCOPE="csla_gate_tb/dut"
        ;;
        csla_opt1)
        TOP_MODULE="csla_32_opt1"
        NETLIST_IN="$RESULTS_DIR/area/csla_opt1_32_synth.v"
        VCD_SCOPE="csla_opt1_gate_tb/dut"
        ;;
        csla_opt2)
        TOP_MODULE="csla_32_opt2"
        NETLIST_IN="$RESULTS_DIR/area/csla_opt2_32_synth.v"
        VCD_SCOPE="csla_opt2_tb/dut"
        ;;
    *)
        echo "Usage: $0 {rca|cla|csla|csla_opt1|csla_opt2} {low|random|high}"
        exit 1
        ;;
esac

case "$WORKLOAD" in
    low|random|high)
        VCD_IN="$RESULTS_DIR/power/${ARCH}_gate_${WORKLOAD}.vcd"
        ;;
    *)
        echo "Usage: $0 {rca|cla|csla} {low|random|high}"
        exit 1
        ;;
esac

SDC_FILE="$STA_DIR/adder.sdc"

export TOP_MODULE
export NETLIST_IN
export SDC_FILE
export VCD_SCOPE
export VCD_IN

export POWER_BEGIN_PS=100000
export POWER_END_PS=1110000

echo "OpenSTA power analysis"
echo "Architecture : $ARCH"
echo "Workload     : $WORKLOAD"
echo "Top module   : $TOP_MODULE"
echo "Netlist      : $NETLIST_IN"
echo "VCD          : $VCD_IN"
echo "VCD scope    : $VCD_SCOPE"
echo "Window       : ${POWER_BEGIN_PS} ps -> ${POWER_END_PS} ps"
echo

"$OPENSTA" -no_splash "$STA_DIR/run_power.tcl"
