#!/usr/bin/env python3
import argparse
import os
import subprocess
import sys

def main():
    # Set up command-line arguments.
    parser = argparse.ArgumentParser(
        description="Generate a CSR using a .cnf configuration file."
    )
    parser.add_argument(
        "-c", "--config", required=True,
        help="Path to the .cnf configuration file (e.g., /config/yourfile.cnf)"
    )
    parser.add_argument(
        "-o", "--output", required=True,
        help="Output directory where the private key and CSR will be saved (e.g., /output)"
    )
    parser.add_argument(
        "-k", "--keyname", required=True,
        help="Name for the private key and CSR file (without extension)"
    )
    args = parser.parse_args()

    # Extract arguments.
    config_file = args.config
    output_dir = args.output
    keyname = args.keyname

    # Validate the configuration file exists.
    if not os.path.isfile(config_file):
        print(f"Error: Configuration file '{config_file}' does not exist.")
        sys.exit(1)

    # Validate the output directory exists.
    if not os.path.isdir(output_dir):
        print(f"Error: Output directory '{output_dir}' does not exist.")
        sys.exit(1)

    # Define paths for private key and CSR.
    private_key_path = os.path.join(output_dir, f"{keyname}.key")
    csr_path = os.path.join(output_dir, f"request_{keyname}.csr")

    try:
        # Generate the private key.
        print("Generating the private key...")
        subprocess.run(
            [
                "openssl", "genpkey", "-algorithm", "RSA",
                "-out", private_key_path, "-pkeyopt", "rsa_keygen_bits:2048"
            ],
            check=True
        )
        print("Private key generated.")

        # Generate the CSR.
        print("Generating the CSR...")
        subprocess.run(
            [
                "openssl", "req", "-new",
                "-key", private_key_path,
                "-out", csr_path,
                "-config", config_file,
                "-sha256"
            ],
            check=True
        )
        print("CSR generated successfully.")
        print(f"Private Key: {private_key_path}")
        print(f"CSR: {csr_path}")

    except subprocess.CalledProcessError:
        print("An error occurred while generating the CSR.")
        sys.exit(1)

if __name__ == "__main__":
    main()
