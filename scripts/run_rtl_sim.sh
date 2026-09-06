#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

TB_FILE="$TB_DIR/adder_tb.v"
SIM_BINARY="$RESULTS_DIR/adder_tb.vvp"

echo "RTL simulation flow"
echo "Project root : $PROJECT_ROOT"
echo "Adder width  : $ADDER_WIDTH"
echo

mkdir -p "$RESULTS_DIR/power"

echo "Compiling RTL and testbench..."

"$IVERILOG" -g2012 \
    -o "$SIM_BINARY" \
    "$TB_FILE" \
    "$RTL_DIR/rca/rca_32.v" \
    "$RTL_DIR/cla/cla_32.v" \
    "$RTL_DIR/csla/csla_32.v"

echo "Compilation successful."
echo
echo "Running simulation..."

"$SIM_BINARY"

echo
echo "RTL simulation completed."
