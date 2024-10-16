

## error1: using local, not aws batch, but forgot to add docker.enabled in the nextflow.config
```
Oct-10 16:31:56.120 [main] ERROR nextflow.cli.Launcher - Unknown executor name: awsbatch
java.lang.IllegalArgumentException: Unknown executor name: awsbatch
        at nextflow.executor.ExecutorFactory.getExecutorClass(ExecutorFactory.groovy:143)
        at nextflow.executor.ExecutorFactory.getExecutor(ExecutorFactory.groovy:187)
        at nextflow.script.ProcessFactory.createProcessor(ProcessFactory.groovy:104)
        at nextflow.script.ProcessFactory$createProcessor.call(Unknown Source)
        at org.codehaus.groovy.runtime.callsite.CallSiteArray.defaultCall(CallSiteArray.java:47)
        at org.codehaus.groovy.runtime.callsite.AbstractCallSite.call(AbstractCallSite.java:125)
        at org.codehaus.groovy.runtime.callsite.AbstractCallSite.call(AbstractCallSite.java:148)
        at nextflow.script.BaseScript.process(BaseScript.groovy:114)
        at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
        at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
        at java.base/jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
        at java.base/java.lang.reflect.Method.invoke(Method.java:566)

```

####solution, add follwing to the nextflow.config file
```
docker {
    enabled = true
}

```


## run quickly finished, but there is no desired output

```
Oct-10 16:33:48.886 [main] DEBUG nextflow.cache.CacheDB - Closing CacheDB done
Oct-10 16:33:48.886 [main] INFO  org.pf4j.AbstractPluginManager - Stop plugin 'nf-amazon@1.11.0'
Oct-10 16:33:48.886 [main] DEBUG nextflow.plugin.BasePlugin - Plugin stopped nf-amazon
Oct-10 16:33:48.902 [main] DEBUG nextflow.util.ThreadPoolManager - Thread pool 'FileTransfer' shutdown completed (hard=false)
Oct-10 16:33:48.902 [main] DEBUG nextflow.script.ScriptRunner - > Execution complete -- Goodbye

```


####solution, add checkIfExists:true to the fromPath 
```
reads_ch = Channel
     .fromPath("bam/*.bam", checkIfExists: true)
```



#### not have enough memory for a process
```
Caused by:
  Process `GLIMPSE_PHASE (SEQW102S013.A11.chr22.01)` terminated with an error exit status (125)
Command executed:

  while read index input output; do 
  
  GLIMPSE_phase  --input SEQW102S013.A11.chr22.01.mpileup  --reference 1000GP.chr22.noNA12878.bcf  --map chr22.b38.gmap.gz  --input-region $input  --output-region $output  --output SEQW102S013.A11.chr22.01_${index}_imputed.bcf  --thread 4
   
   done < chunk.txt

Command exit status:
  125

Command output:
  (empty)

Command error:
  docker: Error response from daemon: Range of CPUs is from 0.01 to 6.00, as there are only 6 CPUs available.
  See 'docker run --help'.

Work dir:
  /Users/yanyan/Documents/projects/20241008_eremid/imputation/glimpse_1_nextflow/work/5a/f9b9da999c255957a720c8771e18ef

Tip: when you have fixed the problem you can continue the execution adding the option `-resume` to the run command line
```

## solution, change the setting in nextflow.config
```
withName: GLIMPSE_CHUNK {
      memory = '15.0G'
      cpus = 6
      container = 'quay.io/biocontainers/glimpse-bio:1.1.1--h0303221_3'
      } 
      

```

## complain fusion in batch run
```
WARN: Local executor only supports default file system (unless Fusion is enabled) -- Check work directory: s3://seqwell-dev/work/eremid_pacbio_20241008/hg38_40k/work
Uploading local `bin` scripts folder to s3://seqwell-dev/work/eremid_pacbio_20241008/hg38_40k/work/tmp/8c/95ffb315357ccc69dde201aa2e403d/bin
Error executing process > 'downsample (7)'

Caused by:
  java.lang.UnsupportedOperationException



WARN: There's no process matching config selector: MULTIQC

```


## solution
```
add the downsample docker image to the nextflow.config file

```