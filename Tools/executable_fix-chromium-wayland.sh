#!/bin/bash

set -e

# Script to automatically apply Wayland flags to the Chromimum desktop entry
# Run this script with sudo after updating Chromium.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

source "$SCRIPT_DIR/set-wayland-flag.sh"

set_wayland_flag "chromium-browser" "Chromium"
