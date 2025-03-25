FROM quay.io/biocontainers/glimpse-bio:2.0.1--ha5d29c5_3

# Switch to root for installation
USER root

# Install wget and tar if needed
RUN curl -fsSL -o bcftools.tar.bz2 https://github.com/samtools/bcftools/releases/download/1.17/bcftools-1.17.tar.bz2 && \
    tar -xjf bcftools.tar.bz2 && \
    mv bcftools-1.17 /usr/local/bcftools && \
    ln -s /usr/local/bcftools/bcftools /usr/local/bin/bcftools

# Verify installation
RUN bcftools --version



