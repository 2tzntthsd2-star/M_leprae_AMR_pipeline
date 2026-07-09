#!/bin/bash

echo "Starting Mycobacterium leprae AMR Pipeline"


# ------------------------
# Create folders
# -----------------------------

mkdir -p aligned bam variant annotation drug_resistance


# -------------------
# BWA Alignment
# -----------------------------

echo "Running BWA alignment"

for acc in SRR6241766 SRR6241767 SRR6241768 SRR6241769 SRR6241770 SRR6241771

do

bwa mem -t 4 \
reference/GCF_000195855.1_ASM19585v1_genomic.fna \
trimmed/${acc}_trim.fastq.gz \
> aligned/${acc}.sam

done



# -----------------------------
# SAM to BAM
# -----------------------------

echo "Converting SAM to BAM"


for acc in SRR6241766 SRR6241767 SRR6241768 SRR6241769 SRR6241770 SRR6241771

do

samtools view -@ 2 -Sb \
aligned/${acc}.sam \
-o bam/${acc}.bam

done



# -----------------------------
# Sorting BAM
# -----------------------------

echo "Sorting BAM files"


for acc in SRR6241766 SRR6241767 SRR6241768 SRR6241769 SRR6241770 SRR6241771

do

samtools sort \
bam/${acc}.bam \
-o bam/${acc}_sorted.bam

done



# --------------------
# Variant Calling
# -----------------------

echo "Calling variants"


for acc in SRR6241766 SRR6241767 SRR6241768 SRR6241769 SRR6241770 SRR6241771

do


bcftools mpileup \
-f reference/GCF_000195855.1_ASM19585v1_genomic.fna \
bam/${acc}_sorted.bam \
-O b \
-o variant/${acc}.bcf


bcftools call \
--ploidy 1 \
-mv \
variant/${acc}.bcf \
-o variant/${acc}.vcf


done



# ----------------------
# Filter variants
# --------------------


echo "Filtering variants"


for acc in SRR6241766 SRR6241767 SRR6241768 SRR6241769 SRR6241771

do


bcftools filter \
-i 'MQ>30 && INFO/DP>5' \
variant/${acc}.vcf \
-Oz \
-o variant/${acc}_filtered.vcf.gz


bcftools index \
variant/${acc}_filtered.vcf.gz


done



#---------------------
# Merge VCF
# --------------------------


echo "Merging variants"


ls variant/*filtered.vcf.gz > merge.txt


bcftools merge \
-l merge.txt \
-Oz \
-o variant/merged.vcf.gz



# ------------------------
# Fix chromosome name
# -----------------------------


echo -e "NC_002677.1\tChromosome" > chromosome.txt


bcftools annotate \
--rename-chrs chromosome.txt \
variant/merged.vcf.gz \
-Oz \
-o variant/merged_fixed.vcf.gz



#-----------------------
# snpEff Annotation
# -----------------------------


echo "Running snpEff"


snpEff \
-s annotation/snpEff_report.html \
Mycobacterium_leprae_tn_gca_000195855 \
variant/merged_fixed.vcf.gz \
> annotation/annotated.vcf



# -----------------------------
# Mutation table
# ------------------------


bcftools query \
-f '%CHROM\t%POS\t%REF\t%ALT\t%ANN\n' \
annotation/annotated.vcf \
> annotation/mutations.tsv



# -----------------------------
# Drug Resistance
#-----------------------


grep -E "rpoB|folP1|gyrA|gyrB" \
annotation/mutations.tsv \
> drug_resistance/resistance_genes.tsv



column -t drug_resistance/resistance_genes.tsv \
| aha \
> drug_resistance/drug_report.html



echo "PIPELINE FINISHED SUCCESSFULLY"
echo "Open drug_resistance/drug_report.html"

