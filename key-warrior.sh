#!/bin/bash

# Help function matching the Docker container's help
show_help() {
  echo "Usage: $0 [-h] -c CONFIG -o OUTPUT -k KEYNAME"
  echo "Generate a CSR using a .cnf configuration file."
  echo ""
  echo "Optional arguments:"
  echo "  -h, --help            show this help message and exit"
  echo "  -c CONFIG, --config CONFIG"
  echo "                        Path to the .cnf configuration file (e.g., /path/to/yourfile.cnf)"
  echo "  -o OUTPUT, --output OUTPUT"
  echo "                        Output directory where the private key and CSR will be saved"
  echo "  -k KEYNAME, --keyname KEYNAME"
  echo "                        Name for the private key and CSR file (without extension)"
  exit 0
}

# Initialize variables
CONFIG=""
OUTPUT=""
KEYNAME=""

# Parse arguments
while [[ "$#" -gt 0 ]]; do
  case $1 in
  -h | --help) show_help ;;
  -c | --config)
    CONFIG="$2"
    shift
    ;;
  -o | --output)
    OUTPUT="$2"
    shift
    ;;
  -k | --keyname)
    KEYNAME="$2"
    shift
    ;;
  *)
    echo "Unknown parameter: $1"
    exit 1
    ;;
  esac
  shift
done

# Validate arguments
if [[ -z "$CONFIG" || -z "$OUTPUT" || -z "$KEYNAME" ]]; then
  echo "Error: All arguments (-c, -o, -k) are required"
  show_help
  exit 1
fi

# Check if config file exists
if [ ! -f "$CONFIG" ]; then
  echo "Error: Config file $CONFIG does not exist"
  exit 1
fi

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT"

# Get the absolute path of the config file
CONFIG_FILE=$(realpath "$CONFIG")
CONFIG_FILENAME=$(basename "$CONFIG_FILE")

# Run the docker container
docker run --rm \
  -v "$CONFIG_FILE:/config/$CONFIG_FILENAME" \
  -v "$(realpath "$OUTPUT"):/output" \
  csr-generator \
  -c "/config/$CONFIG_FILENAME" \
  -o /output \
  -k "$KEYNAME"

echo "CSR generation complete:"
echo " - Private key: $OUTPUT/$KEYNAME.key"
echo " - CSR: $OUTPUT/$KEYNAME.csr"
