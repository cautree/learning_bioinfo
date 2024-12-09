
Note that BCFtools is actively maintained and is intended as a replacement for VCFtools. In a production pipeline, BCFtools should be preferred.


### AC field stands for "Allele Count"

### AN fis "Allele Number"

### AF (Allele Frequency): calculated by dividing "AC" by "AN"


### get rid of multialleletic

```
bcftools view -c1



```


## bcftools cheatsheet 

https://gist.github.com/elowy01/93922762e131d7abd3c7e8e166a74a0b