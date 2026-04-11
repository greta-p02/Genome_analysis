#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -n 2
#SBATCH -J job_fastqc
#SBATCH -t 00:30:00

module load FastQC/0.12.1-Java-17


rawdata=/home/gretap/Genome_analysis/results/01_preprocessing_illumina_dna/E745-1_output*.fastq.gz
output=/home/gretap/Genome_analysis/results/01_preprocessing_illumina_dna


for file in $rawdata
do
fastqc --threads 2 $file -o $output
done
