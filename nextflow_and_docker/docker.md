# mounting data into containers
```

docker run --rm -it -v $(pwd)/containers/data:/data 'community.wave.seqera.io/library/pip_cowsay:131d6a1b707a8e65' /bin/bash

```


## on -with-docker
The nextflow.config in our current working directory contains docker.enabled = true, which tells Nextflow to use Docker to run processes. Without that configuration we would have to specify the -with-docker flag when running the script.


##  tree -a 
tree -a work/8c/738ac55b80e7b6170aa84a68412454
-a makes sure all files are printed including hidden files

## code: capture the namespace context for a code fragment
code work/8c/738ac55b80e7b6170aa84a68412454/.command.run


## create a container in seqera

https://seqera.io/containers/

### in conda.yml file
```
channels:
- conda-forge
- bioconda
dependencies:
- bioconda::nextflow=24.10.3

```


### in Dockerfile
```
FROM mambaorg/micromamba:1.5.10-noble
COPY --chown=$MAMBA_USER:$MAMBA_USER conda.yml /tmp/conda.yml
RUN micromamba install -y -n base -f /tmp/conda.yml \
    && micromamba install -y -n base conda-forge::procps-ng \
    && micromamba env export --name base --explicit > environment.lock \
    && echo ">> CONDA_LOCK_START" \
    && cat environment.lock \
    && echo "<< CONDA_LOCK_END" \
    && micromamba clean -a -y
USER root
ENV PATH="$MAMBA_ROOT_PREFIX/bin:$PATH"

```


## run tools in docker container interactively
```
docker pull community.wave.seqera.io/library/samtools:1.20--b5dfbd93de237464
docker run -it -v ./data:/data community.wave.seqera.io/library/samtools:1.20--b5dfbd93de237464
samtools index /data/bam/reads_mother.bam

```

## Call variants with GATK HaplotypeCaller, run tools in docker container interactively

The GATK documentation gives us the command line to run to perform variant calling on a BAM file.

We need to provide the BAM input file (-I) as well as the reference genome (-R), a name for the output file (-O) and a list of genomic intervals to analyze (-L).

However, we don't need to specify the path to the index file; the tool will automatically look for it in the same directory, based on the established naming and co-location convention. The same applies to the reference genome's accessory files (index and sequence dictionary files, *.fai and *.dict).

```
docker pull community.wave.seqera.io/library/gatk4:4.5.0.0--730ee8817e436867

docker run -it -v ./data:/data community.wave.seqera.io/library/gatk4:4.5.0.0--730ee8817e436867


gatk HaplotypeCaller \
        -R /data/ref/ref.fasta \
        -I /data/bam/reads_mother.bam \
        -O reads_mother.vcf \
        -L /data/ref/intervals.bed


```