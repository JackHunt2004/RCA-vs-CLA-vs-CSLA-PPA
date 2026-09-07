#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

ARCH="${1:-}"

case "$ARCH" in
    rca)
        TOP_MODULE="rca_32"
        RTL_SOURCES="$RTL_DIR/rca/rca_32.v"
        ;;
    cla)
        TOP_MODULE="cla_32"
        RTL_SOURCES="$RTL_DIR/cla/cla_32.v"
        ;;
    csla)
        TOP_MODULE="csla_32"
        RTL_SOURCES="$RTL_DIR/csla/csla_32.v"
        ;;
    csla_opt1)
        TOP_MODULE="csla_32_opt1"
        RTL_SOURCES="$RTL_DIR/csla/csla_32_opt1.v"
        ;;
    csla_opt2)
        TOP_MODULE="csla_32_opt2"
        RTL_SOURCES="$RTL_DIR/csla/csla_32_opt2.v"
        ;;
    *)
        echo "Usage: $0 {rca|cla|csla|csla_opt1|csla_opt2}"
        exit 1
        ;;
esac

NETLIST_OUT="$RESULTS_DIR/area/${ARCH}_32_synth.v"

echo "Yosys synthesis flow"
echo "Architecture : $ARCH"
echo "Top module   : $TOP_MODULE"
echo "RTL source   : $RTL_SOURCES"
echo "Netlist      : $NETLIST_OUT"
echo

mkdir -p "$RESULTS_DIR/area"

YOSYS_SCRIPT="$RESULTS_DIR/area/${ARCH}_synthesis.ys"

sed \
    -e "s|__RTL_SOURCES__|$RTL_SOURCES|g" \
    -e "s|__TOP_MODULE__|$TOP_MODULE|g" \
    -e "s|__SKY130_LIB__|$SKY130_LIB|g" \
    -e "s|__NETLIST_OUT__|$NETLIST_OUT|g" \
    "$SYNTHESIS_DIR/run_yosys.tcl" > "$YOSYS_SCRIPT"

"$YOSYS" -s "$YOSYS_SCRIPT"

echo
echo "Synthesis completed successfully."
