#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

echo "RTL simulation flow"
echo "Project root : $PROJECT_ROOT"
echo "Adder width  : $ADDER_WIDTH"

# RTL simulation commands will be added after
# the common testbench and architecture interfaces
# are finalized.
