# Use an official lightweight base image
FROM debian:stable-slim

# Set working directory
WORKDIR /app

# Install required dependencies
RUN apt-get update && \
    apt-get install -y build-essential wget zlib1g-dev unzip && \
    rm -rf /var/lib/apt/lists/*

# Download and compile samblaster
RUN wget https://github.com/GregoryFaust/samblaster/archive/refs/heads/master.zip && \
    unzip master.zip && \
    cd samblaster-master && \
    make && \
    mv samblaster /usr/local/bin/ && \
    cd .. && rm -rf samblaster-master master.zip 

# Install samtools
RUN cd /usr/local/bin && \
    wget https://github.com/samtools/samtools/releases/download/1.7/samtools-1.7.tar.bz2 && \
    tar xvf samtools-1.7.tar.bz2 && \
    cd samtools-1.7 && \
    ./configure --without-curses --disable-lzma --disable-bz2 --prefix=/usr/local/bin && \
    make && \
    make install && \
    ln -s $PWD/samtools /usr/local/bin/

# Set entrypoint

CMD ["--help"]

