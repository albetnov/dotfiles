#!/bin/bash

set -e

# Script to automatically apply Wayland flags to the VS Code desktop entry
# Run this script with sudo after updating Visual Studio Code.

source "./set-wayland-flag.sh"

set_wayland_flag "code" "VSCode"
