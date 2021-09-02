# seqcover-nf

Quality control sample coverage across genes using `seqcover`:

https://github.com/brentp/seqcover

Example output is available at:

https://brentp.github.io/seqcover/

# Workflow usage

```
nextflow run brwnj/seqcover-nf -r 1.0.1 \
    --crams '*.bam' \
    --reference GRCh38.fasta \
    --genes BRCA1,BRCA2,ATM,TP53,CHEK2,PTEN,CDH1,STK11,PALB2
```
