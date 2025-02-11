FROM ubuntu:22.04

# Set environment variables to prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update and install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    python3 \
    python3-pip \
    python-is-python3 \
    unzip \
    ca-certificates \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2.zip aws

# Install SPAdes from GitHub Releases
RUN wget https://github.com/ablab/spades/releases/download/v4.0.0/SPAdes-4.0.0-Linux.tar.gz \
    && tar -xzf SPAdes-4.0.0-Linux.tar.gz \
    && mv SPAdes-4.0.0-Linux /opt/spades \
    && rm SPAdes-4.0.0-Linux.tar.gz

# Add SPAdes to PATH and ensure binaries are executable
ENV PATH="/opt/spades/bin:$PATH"

# Verify installation using a separate step to avoid breaking the build
RUN ls -l /opt/spades/bin/ && chmod +x /opt/spades/bin/*

# Run version checks
RUN spades.py --version && aws --version

# Set entrypoint to bash for running Nextflow
CMD ["/bin/bash"]
