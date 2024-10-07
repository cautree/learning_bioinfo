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



coker 
```