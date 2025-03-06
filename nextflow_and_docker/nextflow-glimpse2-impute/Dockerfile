FROM continuumio/miniconda3:latest

# Set up the Conda environment
RUN conda install -c conda-forge -c bioconda glimpse-bio=2.0.1 -y \
    && conda clean --all -y

# Ensure Conda environment is activated
ENV PATH="/opt/conda/bin:$PATH"

# Verify installation (optional)


# Default command
CMD ["bash"]