#!/bin/bash

REQUIRE_SUDO=1
ICON_BASE_DIR="/usr/share/applications"

# usage set_wayland_flag(string binary_name, string label)
function set_wayland_flag {
  # Script to automatically apply Wayland flags to the VS Code desktop entry
  # Run this script with sudo after updating Visual Studio Code.

  TARGET="$ICON_BASE_DIR/$1.desktop"
  # You can change this flag if you prefer:
  WAYLAND_FLAG="--enable-features=UseOzonePlatform --ozone-platform=wayland"

  echo "Checking for $2 desktop file at $TARGET..."

  # Check if the desktop file exists
  if [ ! -f "$TARGET" ]; then
    echo "Error: $2 desktop file not found at $TARGET."
    echo "Please verify the path to your code.desktop file."
    exit 1
  fi

  echo "Applying '$WAYLAND_FLAG' flag to $TARGET..."

  # Use sed to modify the Exec line:
  # - Finds the line starting with "Exec=".
  # - It then performs two potential substitutions using the '{ ... }' block and the 't' command:
  #   1. s/\(%U\)\$/ ${WAYLAND_FLAG} \1/ : Tries to find "%U" at the end of the line,
  #      captures it (\1), and replaces the match with the flag followed by the captured "%U".
  #   2. t : If the first substitution was successful (i.e., %U was found), jump to the end
  #      of the commands for this line, skipping the next substitution.
  #   3. s/\$/ ${WAYLAND_FLAG}/ : If the first substitution failed (i.e., %U was NOT found),
  #      this command matches the end of the line ($) and appends the flag.
  # - The '-i' flag tells sed to edit the file in-place.
  # - We need sudo because the file is in /usr/share/applications.
  if [ $REQUIRE_SUDO -eq 1 ]; then
    sudo sed -i "/^Exec=/ { s/\\(%U\\)\$/ ${WAYLAND_FLAG} \\1/; t; s/\$/ ${WAYLAND_FLAG}/ }" "$TARGET"
  else
    sed -i "/^Exec=/ { s/\\(%U\\)\$/ ${WAYLAND_FLAG} \\1/; t; s/\$/ ${WAYLAND_FLAG}/ }" "$TARGET"
  fi

  # Check the exit status of the sed command
  if [ $? -eq 0 ]; then
    echo "Successfully applied Wayland flag to $TARGET."
    echo "You may need to refresh your application launcher for changes to appear."
    # Command to update desktop database - useful for some launchers
    echo "sudo update-desktop-database /usr/share/applications &> /dev/null || true"
  else
    echo "Error applying Wayland flag. Please check the script and the file path."
    exit 1
  fi

  exit 0
}
