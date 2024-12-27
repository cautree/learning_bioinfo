## multi tools biocontainers
https://biocontainers.pro/registry
https://biocontainers.pro/multipackage

## galaxy-util-tools 
You can also install galaxy-util-tools and search for mulled containers in your CLI. 
```
conda create -n galaxy-tool-util -y galaxy-tool-util # Create a new environment with 'galaxy-tool-util' installed
conda activate galaxy-tool-util
mulled-search --destination quay singularity --channel bioconda --search bowtie samtools | grep mulled

```