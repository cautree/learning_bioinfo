https://www.solshenker.com/packaging-conda-environments-for-nextflow-and-aws-batch/


Security credentials
AWS access credentials can be provided in two ways:

Using AWS access and secret keys in your pipeline configuration.

Using IAM roles to grant access to S3 storage on AWS EC2 instances.



new nf training materials

https://training.nextflow.io/basic_training/containers/#create-and-use-conda-like-environments-using-micromamba


## remove conca env by name and path
```
conda  info --envs
## remove by path
conda remove -p "/Users/yy/opt/miniconda3/envs/voi"  --all

```


## To use conda, you need to initiate conda and open a new terminal by running bash:

```
conda init
bash
```


## configuration file priority
Configuration sources are reported below and listed in order of priority:

Parameters specified on the command line (--parameter)
Parameters that are provided using the -params-file option
Config file that are provided using the -c option
The config file named nextflow.config in the current directory
The config file named nextflow.config in the pipeline project directory
The config file $HOME/.nextflow/config
Values defined within the pipeline script itself (e.g., main.nf)
