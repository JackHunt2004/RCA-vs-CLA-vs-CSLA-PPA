#!/usr/bin/env bash

# ============================================================
# Power-Aware Adder Architecture Study
# Common Project Configuration
# ============================================================

# Project root
export PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# ------------------------------------------------------------
# Toolchain
# ------------------------------------------------------------

export IVERILOG="/usr/bin/iverilog"
export YOSYS="/usr/bin/yosys"
export OPENSTA="/home/jackhunt2004/projects/OpenSTA/build/sta"

# ------------------------------------------------------------
# Technology library
# ------------------------------------------------------------

export SKY130_LIB="$HOME/.volare/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib"

# ------------------------------------------------------------
# Design configuration
# ------------------------------------------------------------

export ADDER_WIDTH=32
export CLOCK_PERIOD_NS=10.0

# ------------------------------------------------------------
# Common directories
# ------------------------------------------------------------

export RTL_DIR="$PROJECT_ROOT/rtl"
export TB_DIR="$PROJECT_ROOT/tb"
export SYNTHESIS_DIR="$PROJECT_ROOT/synthesis"
export STA_DIR="$PROJECT_ROOT/sta"
export RESULTS_DIR="$PROJECT_ROOT/results"
export SCRIPTS_DIR="$PROJECT_ROOT/scripts"

# ------------------------------------------------------------
# Dependency checks
# ------------------------------------------------------------

if [[ ! -x "$IVERILOG" ]]; then
    echo "ERROR: Icarus Verilog not found: $IVERILOG" >&2
    return 1 2>/dev/null || exit 1
fi

if [[ ! -x "$YOSYS" ]]; then
    echo "ERROR: Yosys not found: $YOSYS" >&2
    return 1 2>/dev/null || exit 1
fi

if [[ ! -x "$OPENSTA" ]]; then
    echo "ERROR: OpenSTA not found: $OPENSTA" >&2
    return 1 2>/dev/null || exit 1
fi

if [[ ! -f "$SKY130_LIB" ]]; then
    echo "ERROR: Sky130 liberty not found: $SKY130_LIB" >&2
    return 1 2>/dev/null || exit 1
fi
