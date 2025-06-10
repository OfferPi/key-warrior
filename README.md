# key-warrior

A simple, Docker-based CLI tool for generating RSA private keys and Certificate Signing Requests (CSRs).

## Prerequisites

* **Docker** (>= 19.03)
* **Bash** shell (for the `key-warrior` wrapper script)

## Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/OfferPi/key-warrior.git
   cd key-warrior
   ```

2. **Run the installer**

   ```bash
   ./install.sh
   ```

   * Checks for Docker and builds the Docker image.
   * Installs the `key-warrior` command in `/usr/local/bin`.

3. **Verify**

   ```bash
   key-warrior --help
   ```

## Usage

Generate a private key and CSR in one go:

```bash
key-warrior \
  -c /path/to/openssl.cnf \
  -o /path/to/output/dir \
  -k mydomain
```

* `-c, --config` : Path to your OpenSSL `.cnf` file.
* `-o, --output` : Directory where the `.key` and `.csr` will be saved.
* `-k, --keyname` : Base name (no extension) for the generated files.

**Output**:

* `mydomain.key` — Your new private key.
* `request_mydomain.csr` — CSR for submitting to a CA.

## Example

```bash
key-warrior -c ./config/myconfig.cnf -o ./output -k example.com
```

## Uninstall

To remove the `key-warrior` command:

```bash
sudo rm /usr/local/bin/key-warrior
docker image rm generate_key_and_csr
```
```
```
```
```
