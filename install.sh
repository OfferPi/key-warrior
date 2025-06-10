#!/usr/bin/env bash

# Exit immediately on errors
set -e

# Function to print error messages to stderr
echo_err() {
  echo "$@" >&2
}

# Check for Docker dependency
if ! command -v docker >/dev/null 2>&1; then
  echo_err "Error: Docker is not installed or not in PATH."
  echo "Please install Docker and try again."
  exit 1
fi

echo "✔ Docker found."

# Build the Docker image
echo "🔨 Building Docker image 'generate_key_and_csr'..."
docker build -t generate_key_and_csr .

echo "✔ Docker image built successfully."

# Determine install path and permissions
INSTALL_PATH="/usr/local/bin/key-warrior"

# Use sudo if necessary
if [ ! -w "$(dirname "$INSTALL_PATH")" ]; then
  SUDO_CMD="sudo"
else
  SUDO_CMD=""
fi

# Copy wrapper script to PATH
echo "🚀 Installing wrapper script to $INSTALL_PATH"
$SUDO_CMD cp key-warrior.sh "$INSTALL_PATH"
$SUDO_CMD chmod +x "$INSTALL_PATH"

# Final message
echo "🎉 Installation complete!"
echo "You can now run 'csr-generator --help' from anywhere."
