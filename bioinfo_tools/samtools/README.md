
## reheader BAM file
```

samtools view -H $BAM | sed "s/Solid5500XL/Solid/" | samtools reheader - $BAM

```