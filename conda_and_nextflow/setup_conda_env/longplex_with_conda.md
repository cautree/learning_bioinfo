---
output:
  word_document: default
  html_document: default
---
# run LongPlex Demux with conda

## 1. install git
```
sudo yum install git

```

## 2. Install mamba/conda
```
curl -L -O "https://github.com/conda-forge/miniforge/releases/download/24.9.2-0/Miniforge3-Linux-x86_64.sh"
bash Miniforge3-$(uname)-$(uname -m).sh
```

## 3. Initialize conda/mamba, after running the two lines below, exit and reconnect
```
conda init
mamba init
```

## 4. create nextflow conda env
```
mamba create -n nextflow -c bioconda nextflow
mamba activate nextflow

```

## 5. Clone LongPlex and run the test command.
```
git clone https://github.com/seqwell/LongPlex.git
cd LongPlex
```

## 6. run the test sample

```
nextflow run \
-profile conda \
main.nf \
-c nextflow.config \
--pool_sheet "${PWD}/tests/pool_sheet.csv" \
--output "${PWD}/test_output" \
-with-report \
-with-trace \
-resume

```

## note

Suggest using fresh linux instance and set up the env accordingly.  


## note: conda can not work with aws batch
https://www.nextflow.io/docs/latest/conda.html#use-existing-conda-environments
The Conda environment feature is not supported by executors that use remote object storage as a work directory. For example, AWS Batch.