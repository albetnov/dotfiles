#!/bin/bash

set -e

# Script to automatically apply Wayland flags to the VS Code desktop entry
# Run this script with sudo after updating Visual Studio Code.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

source "$SCRIPT_DIR/set-wayland-flag.sh"

set_wayland_flag "code" "VSCode"
