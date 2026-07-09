# Mycobacterium leprae AMR Prediction Pipeline

This project performs whole genome analysis for detection of antimicrobial resistance mutations.

## Pipeline

SRA Download
↓
Quality Control
↓
BWA Alignment
↓
Variant Calling
↓
snpEff Annotation
↓
Drug Resistance Prediction

## Tools

- FastQC
- fastp
- BWA
- SAMtools
- BCFtools
- snpEff

## Output

- Mutation annotation report
- Drug resistance prediction report

## Reports

### Quality Control
FastQC reports are available in:

reports/QC/

### Mutation Annotation
snpEff annotation results:

reports/Mutation/

### Drug Resistance Prediction

reports/Resistance/


## Pipeline Execution

Run complete workflow:

```bash
bash script/leprae_pipeline.sh

