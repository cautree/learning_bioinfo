FROM rocker/tidyverse:latest

# Set environment variables to prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies required for devtools
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Install devtools package in R
RUN R -e "install.packages('devtools', repos='https://cloud.r-project.org/')"

# Install plasmapR using devtools
RUN R -e "devtools::install_github('bradyajohnston/plasmapr')"

# Verify installation
RUN R -e "library(plasmapR)"

# Set default command
CMD ["R"]