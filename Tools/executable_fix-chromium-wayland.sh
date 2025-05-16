#!/bin/bash

set -e

# Script to automatically apply Wayland flags to the Chromimum desktop entry
# Run this script with sudo after updating Chromium.

source "./set-wayland-flag.sh"

set_wayland_flag "chromium-browser" "Chromium"
