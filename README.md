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

[Open FastQC Report](fastqc_reports/SRR6241766_fastqc.html)


### Mutation Annotation

[Open snpEff Annotation Report](annotation/snpEff_report.html)

[Open Mutation Report](annotation/mutation_report.html)


### Drug Resistance Prediction

[Open AMR Prediction Report](drug_resistance/drug_report.html)

