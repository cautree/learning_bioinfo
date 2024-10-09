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
