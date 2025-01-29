notes 


## see the nf-core pipeline
```
nf-core list | less

nf-core create -n nanopore_bbduk_demux -d "This pipeline demux data generated from nanopore using bbduk" -a "Yanyan Liu" --plain

tree --charset ascii -L 2 nf-core-nanopore_bbduk_demux
```


## create nf-core template
```
nf-core create -n nanopore_bbduk_demux -d "This pipeline demux data generated from nanopore using bbduk" -a "Yanyan Liu" --plain

```

## tree, ignore other weird characters
```
tree --charset ascii -L 2 nf-core-nanopore_bbduk_demux
```


## docker run --rm
--rm parameter is used to automatically remove the container when it exits.
```
docker run --rm hello-world
```


## copy file btw local and containers
```

docker ps -a

echo hi > hi.txt

docker cp hi.txt eb15b61c0c8e:/root/

##start container
docker start -ai eb15b61c0c8e

docker cp eb15b61c0c8e:/root/hi.txt .


```


## Sharing between host and container
```
## mounting data from the current directory (using the Unix command pwd) to /work in the container.
## pUC19_2.fa is inside the data folder

docker run --rm -v $(pwd)/data:/work davetang/bwa:0.7.17 bwa index pUC19_2.fa

docker run --rm -v $(pwd)/data:/data/ docker.io/biocontainers/bwa:v0.7.17-3-deb_cv1 bwa index pUC19_2.fa

```


## on permission
There is a -u or --user parameter that can be used with docker run to run a container using a specific user. 

```
docker pull ubuntu

stat -f "%u:%g" $HOME
#502:20

docker run -v $(pwd):/$(pwd) -u $(stat -f "%u:%g" $HOME) ubuntu:latest touch $(pwd)/test_mine.txt
docker run -v $(pwd):/$(pwd)  ubuntu:latest touch $(pwd)/test_mine.txt

```


## run other than root
```
docker run -it \
  -v ~/my_data:/data \
  -e MYUID=$(id -u) \
  -e MYGID=$(id -g) \
  -e ME=$(whoami) \
 docker.io/biocontainers/bwa:v0.7.17-3-deb_cv1 /bin/bash
```


## -w Working directory inside the container

it handy to mount my current directory to the same path inside a Docker container and to set it as the working directory; the directory will be automatically created inside the container if it does not already exist. 
When the container starts up, I will conveniently be in my current directory.

```
##inside nextflow_and_docker folder
docker run --rm -it -u $(stat -f "%u:%g" ${HOME}) -v $(pwd):$(pwd) -w $(pwd) davetang/bwa:0.7.17 bwa index data/pUC19_2.fa
```


##snpeff
```
java -Xmx40G -jar  /home/ec2-user/software/snpEff/snpEff.jar -v  GRCh38.86 221017-purePlex24-F10.chr22_sampled.vcf > test.chr22.ann.vcf
```



##

https://stackoverflow.com/questions/65398109/nextflow-in-cmd-process-is-expanded


## pipeline-level parameter vs nextflow-level parameter

It's helpful to distinguish Nextflow-level parameters from pipeline-level parameters. For parameters that apply to a pipeline, we use a double hyphen (--), whereas we use a single hyphen (-) for parameters that modify a specific Nextflow setting, e.g. the -resume feature we used earlier.

## configuration order

(from lowest to highest priority):

Parameters defined in pipeline scripts (e.g. main.nf)

The config file $HOME/.nextflow/config

The config file nextflow.config in the project directory

The config file nextflow.config in the launch directory

Config file specified using the -c <config-file> option

Parameters specified in a params file (-params-file option)

Parameters specified on the command line (--something value)

A handy guide to understand configuration precedence is in order of 'distance from the command-line invocation'. Parameters specified directly on the CLI --example foo are "closer" to the run than configuration specified in the remote repository.

## double qutes output filename
Very important to remember: you have to use double quotes around the output filename expression (NOT single quotes) or it will fail.


## ANSI logging
By default, the ANSI logging system writes the logging from multiple calls to the same process on the same line. Fortunately, we can disable that behavior.

Run the command again with the -ansi-log false option
```
nextflow run hello-world.nf -ansi-log false
```


## more on config

process FASTQC {
    tag "FASTQC on $sample_id"
    conda 'fastqc=0.12.1'
    publishDir params.outdir, mode:'copy'

    input:
    tuple val(sample_id), path(reads)

    output:
    path "fastqc_${sample_id}_logs"

    script:
    """
    fastqc.sh "$sample_id" "$reads"
    """
}

scale up the cups by the how many samples you have
```
process {
    withName: 'FASTQC' {
        cpus = { reads.size() }
        tag = { "Total size: ${reads*.size().sum() as MemoryUnit}" }
    }
}

```

## how to use -c

Do not use -c <file> to specify parameters as this will result in errors. Custom config files specified with -c must only be used for tuning process resource specifications, other infrastructural tweaks (such as output directories), or module arguments (args).

## ext.args 
While some tool arguments are included as a part of a module. To make nf-core modules sharable across pipelines, most tool arguments are defined in the conf/modules.conf file in the pipeline code under the ext.args entry.
```
singularity {
    enabled    = true
    autoMounts = true
}

process {
    withName: 'MULTIQC' {
            ext.args   = { "--title \"my_custom_title\"" }
        }
}

```