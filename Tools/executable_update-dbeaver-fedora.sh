#!/bin/bash
#
# Script to check for and install/update DBeaver Community Edition on Fedora.
#

# Exit on error, treat unset variables as an error, and propagate pipeline errors.
set -eo pipefail

# --- Configuration Variables ---
# Default download directory
DEFAULT_DOWNLOAD_DIR="$HOME/Downloads/dbeaver"
# Default filename for the downloaded RPM
DEFAULT_DOWNLOAD_FILENAME="dbeaver_latest.rpm"

# User-configurable variables (can be overridden by environment variables if needed)
DOWNLOAD_DIR="${DBEAVER_DOWNLOAD_DIR:-$DEFAULT_DOWNLOAD_DIR}"
DOWNLOAD_FILENAME="${DBEAVER_DOWNLOAD_FILENAME:-$DEFAULT_DOWNLOAD_FILENAME}"
DOWNLOAD_PATH="$DOWNLOAD_DIR/$DOWNLOAD_FILENAME"

# DBeaver package name
DBEAVER_PKG_NAME="dbeaver-ce"

# Script options
NO_INSTALL=0
SHOW_HELP=0

# --- Helper Functions ---

# Function to display help message
show_help() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS]

This script checks for the latest version of DBeaver Community Edition,
compares it with the installed version, and optionally downloads and installs it.
It is intended for Fedora Linux (RPM-based).

Options:
  --no-install    Check for updates and print version information only.
                  Does not download or install.
  --help          Display this help message and exit.

Environment Variables (optional overrides):
  DBEAVER_DOWNLOAD_DIR      Set custom download directory (default: $DEFAULT_DOWNLOAD_DIR)
  DBEAVER_DOWNLOAD_FILENAME Set custom download filename (default: $DEFAULT_DOWNLOAD_FILENAME)
EOF
}

# Function to check for required dependencies
check_dependencies() {
  local missing_deps=0
  for cmd in curl jq rpm dnf sudo; do
    if ! command -v "$cmd" &>/dev/null; then
      echo "Error: Required command '$cmd' not found." >&2
      missing_deps=1
    fi
  done
  if [ "$missing_deps" -eq 1 ]; then
    echo "Please install the missing dependencies and try again." >&2
    exit 1
  fi
}

# Function to get the latest DBeaver version tag and download URL from GitHub API
get_latest_dbeaver_info() {
  echo "Fetching latest DBeaver version information..."
  local api_url="https://api.github.com/repos/dbeaver/dbeaver/releases/latest"
  local response
  local curl_exit_code

  # Fetch data using curl.
  # --silent: Don't show progress meter or error messages.
  # --location: Follow redirects.
  # --fail: Fail silently (no output) on HTTP errors (4xx, 5xx). Curl will exit with 22.
  response=$(curl --silent --location --fail "$api_url")
  curl_exit_code=$?

  if [ "$curl_exit_code" -ne 0 ]; then
    echo "Error: curl failed to fetch data from GitHub API (exit code: $curl_exit_code)." >&2
    echo "URL: $api_url" >&2
    # The response might be empty due to --fail, or could be an error page from a proxy if --fail didn't catch it.
    if [ -n "$response" ]; then
      echo "Response from curl (if any): $response" >&2
    fi
    return 1
  fi

  if [ -z "$response" ]; then
    # This case might be redundant if --fail works as expected, but good as a safeguard.
    echo "Error: Fetched empty response from GitHub API. URL: $api_url" >&2
    return 1
  fi

  # Validate that the response is JSON and contains expected top-level keys.
  # jq -e will set an exit code if the expression is false or null, or if input is not JSON.
  if ! echo "$response" | jq -e '.tag_name and .assets' >/dev/null 2>&1; then
    echo "Error: GitHub API response is not valid JSON or missing expected fields ('tag_name', 'assets')." >&2
    echo "URL: $api_url" >&2
    # Avoid printing potentially huge invalid response. User can curl manually.
    return 1
  fi

  LATEST_VERSION_TAG=$(echo "$response" | jq -r .tag_name)

  # Robustly extract the RPM URL.
  # This jq query:
  # 1. Iterates through .assets[].
  # 2. Selects items that are objects, have a .name that is a string, and match the RPM criteria.
  #    - `type == "object"`: Ensures we only process JSON objects from the assets array.
  #    - `(.name? | type == "string")`: Safely checks if .name exists and is a string.
  #    - `(.name | endswith(...))` and `(.name | contains(...))`: String checks, safe due to prior type check.
  # 3. Extracts .browser_download_url? (safely, returns null if key is missing on a selected object).
  # 4. Collects all such URLs into an array.
  # 5. `map(select(. != null))`: Filters out any nulls from the array (e.g. if an asset matched but had no URL).
  # 6. `.[0] // ""`: Takes the first URL from the filtered array, or defaults to an empty string if no suitable URL was found.
  LATEST_RPM_URL=$(echo "$response" | jq -r '
    [
      .assets[] |
      select(
        type == "object" and
        (.name? | type == "string") and
        (.name | endswith(".x86_64.rpm")) and
        (.name | contains("ce-"))
      ) | .browser_download_url?
    ] | map(select(. != null)) | .[0] // ""
  ')

  if [ -z "$LATEST_VERSION_TAG" ] || [ "$LATEST_VERSION_TAG" == "null" ]; then
    echo "Error: Could not determine the latest version tag from GitHub API response." >&2
    echo "Check API manually: $api_url" >&2
    return 1
  fi

  # LATEST_RPM_URL will be an empty string if not found by the jq query due to `// ""`.
  if [ -z "$LATEST_RPM_URL" ]; then
    echo "Error: Could not determine the download URL for a suitable RPM from GitHub API response." >&2
    echo "Filters: must be an x86_64.rpm for community edition (ce-)." >&2
    echo "Check API manually for available assets: $api_url" >&2
    return 1
  fi

  echo "Latest DBeaver version available: $LATEST_VERSION_TAG"
  return 0
}

# Function to get the installed DBeaver version
get_installed_dbeaver_version() {
  if rpm -q "$DBEAVER_PKG_NAME" &>/dev/null; then
    # Extracts only the version part, e.g., 23.3.0 from dbeaver-ce-23.3.0-1.x86_64
    INSTALLED_VERSION=$(rpm -q --qf "%{VERSION}" "$DBEAVER_PKG_NAME")
    echo "Installed DBeaver version: $INSTALLED_VERSION"
  else
    INSTALLED_VERSION="not_installed"
    echo "DBeaver ($DBEAVER_PKG_NAME) is not currently installed."
  fi
}

# Function to compare two versions (version1 > version2)
# Returns 0 (true) if version1 is greater than version2, 1 (false) otherwise.
version_gt() {
  local ver1="$1"
  local ver2="$2"
  # Ensure versions are not empty before comparison
  if [ -z "$ver1" ] || [ -z "$ver2" ]; then
    # echo "Warning: Attempting to compare an empty version string ('$ver1' vs '$ver2')." >&2
    return 1 # Consider this not greater than
  fi
  [ "$ver1" != "$ver2" ] && [ "$(printf '%s\n%s\n' "$ver1" "$ver2" | sort -V | head -n 1)" == "$ver2" ]
}

# --- Argument Parsing ---
while [[ $# -gt 0 ]]; do
  case "$1" in
  --no-install)
    NO_INSTALL=1
    shift
    ;;
  --help)
    SHOW_HELP=1
    shift
    ;;
  *)
    echo "Unknown option: $1" >&2
    show_help
    exit 1
    ;;
  esac
done

if [ "$SHOW_HELP" -eq 1 ]; then
  show_help
  exit 0
fi

# --- Sanity Checks ---
# Check if running on Fedora
if ! grep -q -i "fedora" /etc/os-release; then
  echo "Warning: This script is primarily designed for Fedora Linux." >&2
  echo "You may proceed, but compatibility is not guaranteed." >&2
  # To make it strict, uncomment the following lines:
  # echo "Error: This script is intended for Fedora Linux only." >&2
  # exit 1
fi

check_dependencies

# --- Main Logic ---
echo "--- DBeaver Updater for Fedora ---"

if ! get_latest_dbeaver_info; then
  # get_latest_dbeaver_info already prints detailed errors
  exit 1
fi

get_installed_dbeaver_version

# Handle --no-install mode
if [ "$NO_INSTALL" -eq 1 ]; then
  echo "--- Mode: Check Only (No Install) ---"
  if [[ "$INSTALLED_VERSION" == "not_installed" ]]; then
    echo "Status: DBeaver ($DBEAVER_PKG_NAME) is not installed. Latest version is $LATEST_VERSION_TAG."
  elif version_gt "$LATEST_VERSION_TAG" "$INSTALLED_VERSION"; then
    echo "Status: An update is available. Installed: $INSTALLED_VERSION, Latest: $LATEST_VERSION_TAG."
  elif [[ "$LATEST_VERSION_TAG" == "$INSTALLED_VERSION" ]]; then
    echo "Status: DBeaver is already up to date (Version: $INSTALLED_VERSION)."
  else
    # This case could happen if LATEST_VERSION_TAG is somehow older, or INSTALLED_VERSION is a pre-release/custom build
    echo "Status: Installed version ($INSTALLED_VERSION) seems newer than or same as the latest official release ($LATEST_VERSION_TAG)."
    echo "If installed version is indeed older, there might be an issue with version comparison or fetched latest version."
  fi
  exit 0
fi

# Proceed with installation/update logic
NEEDS_INSTALL=0
NEEDS_UPDATE=0

if [[ "$INSTALLED_VERSION" == "not_installed" ]]; then
  NEEDS_INSTALL=1
  echo "DBeaver $LATEST_VERSION_TAG is not installed."
elif version_gt "$LATEST_VERSION_TAG" "$INSTALLED_VERSION"; then
  NEEDS_UPDATE=1
  echo "An update for DBeaver is available: $INSTALLED_VERSION -> $LATEST_VERSION_TAG"
elif [[ "$LATEST_VERSION_TAG" == "$INSTALLED_VERSION" ]]; then
  echo "DBeaver is already up to date (Version: $INSTALLED_VERSION)."
  exit 0
else
  echo "Warning: Installed DBeaver version ($INSTALLED_VERSION) is newer than or same as the latest official release ($LATEST_VERSION_TAG)."
  echo "No action will be taken. If you believe this is incorrect, check versions manually."
  exit 0
fi

# Confirm before proceeding with download/install
if [ "$NEEDS_INSTALL" -eq 1 ] || [ "$NEEDS_UPDATE" -eq 1 ]; then
  read -r -p "Do you want to download and install DBeaver version $LATEST_VERSION_TAG? (Y/n): " confirmation
  if [[ ! "$confirmation" =~ ^([yY][eE][sS]|[yY])$ && -n "$confirmation" ]]; then
    echo "Installation aborted by user."
    exit 0
  fi

  # Create download directory if it doesn't exist
  echo "Creating download directory: $DOWNLOAD_DIR"
  if ! mkdir -p "$DOWNLOAD_DIR"; then
    echo "Error: Failed to create download directory $DOWNLOAD_DIR." >&2
    exit 1
  fi
  echo "Download directory created/ensured."

  # Download the RPM
  echo "Downloading DBeaver $LATEST_VERSION_TAG from $LATEST_RPM_URL to $DOWNLOAD_PATH..."
  # Using curl with -o for output, -L for redirects. --fail for server errors.
  if ! curl -L --fail -o "$DOWNLOAD_PATH" "$LATEST_RPM_URL"; then
    echo "Error: Failed to download DBeaver RPM. curl exit code: $?" >&2
    # Clean up partially downloaded file if it exists
    [ -f "$DOWNLOAD_PATH" ] && rm "$DOWNLOAD_PATH"
    exit 1
  fi
  echo "Download complete."

  # Verify download (file exists and is not empty)
  if [ ! -s "$DOWNLOAD_PATH" ]; then
    echo "Error: Downloaded file $DOWNLOAD_PATH is empty or does not exist." >&2
    exit 1
  fi

  # Install the RPM
  echo "Installing DBeaver using dnf. This may require sudo privileges."
  if sudo dnf install -y "$DOWNLOAD_PATH"; then
    echo "DBeaver version $LATEST_VERSION_TAG installed successfully!"
    read -r -p "Do you want to remove the downloaded RPM file ($DOWNLOAD_PATH)? (Y/n): " cleanup_confirmation
    if [[ "$cleanup_confirmation" =~ ^([yY][eE][sS]|[yY])$ || -z "$cleanup_confirmation" ]]; then # Default to Yes if empty
      if rm "$DOWNLOAD_PATH"; then
        echo "Downloaded file removed."
      else
        echo "Warning: Could not remove $DOWNLOAD_PATH."
      fi
    fi
  else
    echo "Error: Failed to install DBeaver." >&2
    echo "The downloaded RPM is available at: $DOWNLOAD_PATH"
    exit 1
  fi
else
  # This case should have been handled earlier, but as a fallback:
  echo "No action required."
fi

echo "--- DBeaver Updater Finished ---"
exit 0
