#!/bin/sh

echo "Finding new VSCode version (fedora-only)..."

# Exit immediately if a command exits with a non-zero status.
set -e

# Script to fetch the latest VS Code version number from GitHub API
# and download/install the RPM package for Fedora.

# --- Check for required tools ---

# Check if curl is installed, exit early if not.
if ! command -v curl &> /dev/null; then
    echo "Error: curl is not installed. Please install it."
    exit 1
fi

# Check if jq is installed, exit early if not.
if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed. Please install it."
    exit 1
fi

SHOULD_INSTALL=true
SHOW_HELP=false

# --- Parse command-line arguments ---
while [ "$#" -gt 0 ]; do
    case "$1" in
        --no-install)
            SHOULD_INSTALL=false
            ;;
        --help)
            SHOW_HELP=true
            ;;
        *)
            # Unknown option, print usage and exit early.
            echo "Unknown option: $1"
            echo "Usage: $0 [--no-install] [--help]"
            exit 1
            ;;
    esac
    shift
done

# Show help and exit early if requested.
if [ "$SHOW_HELP" = true ]; then
    echo "Usage: $0 [--no-install] [--help]"
    echo "--no-install: Skip the installation of VS Code"
    echo "--help: Show this help message"
    exit 0
fi

# This endpoint returns information about the latest release of the microsoft/vscode repository
API_URL="https://api.github.com/repos/microsoft/vscode/releases/latest"
DOWNLOAD_DIR="$HOME/Downloads/vscode" # Use a variable name that indicates it's a directory
DOWNLOAD_FILENAME="vscode_latest.rpm" # Specify a filename for the download
DOWNLOAD_PATH="$DOWNLOAD_DIR/$DOWNLOAD_FILENAME" # Combine directory and filename

echo "Fetching latest VS Code release information from GitHub API..."

# --- Fetch data and parse the version ---
# Use -s for silent, -f for fail on error, -L for follow redirects
# Fetch the latest version, exit early if curl or jq fails.
LATEST_VERSION=$(curl -sfL "$API_URL" | jq -r '.tag_name')

# Exit early if the latest version could not be fetched or parsed.
if [ -z "$LATEST_VERSION" ]; then
    echo "Error: Could not fetch or parse the latest VS Code version."
    echo "API Response might be unexpected or there was a network issue."
    # Optionally, print the curl output for debugging if it failed silently
    # curl -sfL "$API_URL"
    exit 1
fi

# Get the currently installed VS Code version
# Use 'command -v code' to check if code is in the PATH before calling it
if command -v code &> /dev/null; then
  installed_code_version=$(code --version | head -n 1)
else
  installed_code_version="not installed" # Handle case where code is not installed
fi

# If installed version is already the latest, print message and exit early.
if [ "$installed_code_version" = "$LATEST_VERSION" ]; then
    echo "You are already using the latest VS Code (version $LATEST_VERSION)!"
    exit 0
fi

# If we reach here, a new version is available.
echo "Latest VS Code Version available: $LATEST_VERSION"
if [ "$installed_code_version" != "not installed" ]; then
  echo "Currently installed version: $installed_code_version"
fi

# Proceed with installation only if SHOULD_INSTALL is true.
if [ "$SHOULD_INSTALL" = true ]; then
    # Create the download directory if it doesn't exist.
    mkdir -p "$DOWNLOAD_DIR"

    echo "Downloading VS Code RPM to $DOWNLOAD_PATH..."
    # Use -o to specify the output filename and path. Exit early if download fails.
    if ! curl -L -o "$DOWNLOAD_PATH" "https://code.visualstudio.com/sha/download?build=stable&os=linux-rpm-x64"; then
        echo "Error: curl download failed."
        exit 1
    fi

    echo "Download complete."

    # Check if the downloaded file exists and is not empty. Exit early if not.
    if [ ! -s "$DOWNLOAD_PATH" ]; then
        echo "Error: Downloaded file $DOWNLOAD_PATH is empty or does not exist."
        exit 1
    fi

    echo "Installing VS Code from $DOWNLOAD_PATH..."
    # Use sudo dnf install to install the RPM package. Exit early if installation fails.
    if ! sudo dnf install -y "$DOWNLOAD_PATH"; then
        echo "Error: dnf installation failed."
        exit 1
    fi

    echo "VS Code installation complete."

    # Execute the fix-vscode-wayland.sh script if it exists.
    if [ -f "./fix-vscode-wayland.sh" ]; then
        echo "Applying Wayland fix..."
        . ./fix-vscode-wayland.sh
    else
        echo "Warning: fix-vscode-wayland.sh not found in the current directory."
    fi
else
    # If not installing, print message.
    echo "Skipping installation as per user request (--no-install)."
fi

# Script finished successfully.
exit 0
