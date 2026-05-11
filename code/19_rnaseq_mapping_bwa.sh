#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -J job_mapping_canu
#SBATCH -t 04:00:00
#SBATCH --output=%x.%j.out

module load BWA/0.7.19-GCCcore-13.3.0 SAMtools/1.22.1-GCC-13.3.0


assemblycanu=/home/gretap/Genome_analysis/data/polished_canu/1_pilon_canu.fasta
output_bh=/home/gretap/Genome_analysis/results/15_rnaseq_mapping/BH
output_serum=/home/gretap/Genome_analysis/results/15_rnaseq_mapping/serum
trimmed_bh=/home/gretap/Genome_analysis/data/trimmed_data/BH/*_1_paired.fastq.gz
trimmed_serum=/home/gretap/Genome_analysis/data/trimmed_data/serum/*_1_paired.fastq.gz

bwa index $assemblycanu

for R1 in $trimmed_bh
do

R2="${R1%_1_paired.fastq.gz}_2_paired.fastq.gz"
name=$(basename "$R1" _1_paired.fastq.gz)

bwa mem -t 2 \
$assemblycanu $R1 $R2 | samtools sort -@ 2 -o $output_bh/${name}_sorted.bam

samtools index -@ 2 $output_bh/${name}_sorted.bam

done


for R1 in $trimmed_serum
do

R2="${R1%_1_paired.fastq.gz}_2_paired.fastq.gz"
name=$(basename "$R1" _1_paired.fastq.gz)

bwa mem -t 2 \
$assemblycanu $R1 $R2 | samtools sort -@ 2 -o $output_serum/${name}_sorted.bam

samtools index -@ 2 $output_serum/${name}_sorted.bam

done





