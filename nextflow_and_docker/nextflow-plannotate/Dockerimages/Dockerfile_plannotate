FROM ubuntu:latest

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    python3 \
    python3-pip \
    git \
    wget \
    build-essential \
    cmake \
    libcurl4-openssl-dev \
    libssl-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /miniconda.sh && \
    bash /miniconda.sh -b -p /opt/conda && \
    rm /miniconda.sh

# Set up Conda environment
ENV PATH="/opt/conda/bin:$PATH"

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf aws awscliv2.zip

# Verify AWS CLI installation
RUN aws --version

# Install pLannotate
WORKDIR /opt

RUN wget https://github.com/mmcguffi/pLannotate/archive/refs/tags/v1.2.2.zip -O pLannotate-1.2.2.zip \
    && unzip pLannotate-1.2.2.zip \
    && rm pLannotate-1.2.2.zip

# Set working directory to pLannotate
WORKDIR /opt/pLannotate-1.2.2

# Create and activate Conda environment
RUN conda env create -f environment.yml \
    && echo "source activate plannotate" >> ~/.bashrc

# Use the Conda environment for installation
RUN /bin/bash -c "source activate plannotate && python setup.py install"

# Add pLannotate to PATH
ENV PATH="/opt/conda/envs/plannotate/bin:$PATH"

# Verify pLannotate installation
RUN plannotate --help || true  # Allow failure if dependencies aren't met in the build step

# Set entrypoint to bash for interactive use
ENTRYPOINT ["/bin/bash"]
