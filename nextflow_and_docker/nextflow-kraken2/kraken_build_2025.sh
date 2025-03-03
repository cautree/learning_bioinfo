#!/bin/bash

mkdir -p /home/ec2-user/kraken/k2-bacteria-db/
rsync --copy-links --recursive --times --verbose rsync://ftp.ncbi.nlm.nih.gov/refseq/release/bacteria/ /home/ec2-user/kraken/k2-bacteria-db/library/bacteria/
kraken2-build --download-taxonomy --db /home/ec2-user/kraken/k2-bacteria-db/
kraken2-build --build --db /home/ec2-user/kraken/k2-bacteria-db/
