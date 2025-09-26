#!/bin/bash

# Run this 
# chmod +x setup-macos.sh
# ./setup-macos.sh

set -e

# Install Homebrew if not present
if ! command -v brew &>/dev/null; then
  echo "Homebrew not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install system dependencies
brew install openocd gcc-arm-none-eabi python jq

# (Optional) Install Python packages globally or recommend a venv/uv step
pip3 install --user gatorgrade

echo "All dependencies installed!"