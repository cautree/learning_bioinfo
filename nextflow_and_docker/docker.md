# mounting data into containers
```

docker run --rm -it -v $(pwd)/containers/data:/data 'community.wave.seqera.io/library/pip_cowsay:131d6a1b707a8e65' /bin/bash

```


## on -with-docker
The nextflow.config in our current working directory contains docker.enabled = true, which tells Nextflow to use Docker to run processes. Without that configuration we would have to specify the -with-docker flag when running the script.
