

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

