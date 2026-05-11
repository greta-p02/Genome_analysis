#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -n 2
#SBATCH -J job_fastqc
#SBATCH -t 00:30:00

module load FastQC/0.12.1-Java-17


rawdata_bh=/home/gretap/Genome_analysis/data/trimmed_data/BH/*_paired.fastq.gz
rawdata_serum=/home/gretap/Genome_analysis/data/trimmed_data/serum/*_paired.fastq.gz
output_bh=/home/gretap/Genome_analysis/results/14_rnaseq_trimmed_qc/BH
output_serum=/home/gretap/Genome_analysis/results/14_rnaseq_trimmed_qc/serum


for file in $rawdata_bh
do
fastqc --threads 2 $file -o $output_bh
done


for file in $rawdata_serum
do
fastqc --threads 2 $file -o $output_serum
done
