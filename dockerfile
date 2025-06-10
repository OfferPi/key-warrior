FROM python:3.9-slim

# Install OpenSSL for CSR generation
RUN apt-get update \
    && apt-get install -y openssl \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy the CSR generation script
COPY generate_key_and_csr.py /app/

# Define mount points for configuration and output
VOLUME ["/config", "/output"]

# Default command to run the CSR generator
ENTRYPOINT ["python", "generate_csr.py"]
