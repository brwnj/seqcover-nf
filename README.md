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

## Using checkpoints

Nextflow will checkpoint the outputs from the previous run and one
can use `-resume` to utilize those checkpoints when trying a new
gene list across the same bams/crams. The follow-up run would look
like:

```
nextflow run brwnj/seqcover-nf -r 1.0.1 -resume \
    --crams '*.bam' \
    --reference GRCh38.fasta \
    --genes "CR2,PAX5,MS4A1,CD22,CXCR5,BACH2,CD19,CDD79B,P2RX5"
    --outdir upregulated_pathway
```
