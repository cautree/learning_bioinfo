## useful commands for conda


### make the prompt nice
```
cd project-dir 
conda create --prefix ./env \
python=3.6 \
matplotlib=3.1 \
tensorflow=2.0 

conda config --set env_prompt '({name})'

conda activate ./env
```

### Listing existing environments
```
conda list --name bioinfo
conda list --prefix /path/to/conda-env
conda list #list for the active env

```

### Deleting entire environments
```
conda remove --name my-first-conda-env --all --yes
conda remove --prefix /path/to/conda-env/ --all --yes

```

### install packages 
You install packages into environments using conda install; you install packages into an active environment using pip install