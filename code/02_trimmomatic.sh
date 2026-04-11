#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -n 2
#SBATCH -J job_trimmomatic
#SBATCH -t 03:00:00

module load Trimmomatic/0.39-Java-17


rawdata=/proj/uppmax2026-1-61/Genome_Analysis/1_Zhang_2017/genomics_data/Illumina/
output=/home/gretap/Genome_analysis/results/01_preprocessing_illumina_dna
forward=E745-1.L500_SZAXPI015146-56_1_clean.fq.gz
reverse=E745-1.L500_SZAXPI015146-56_2_clean.fq.gz

trimmomatic PE -threads 2 -phred33 \
$rawdata/$forward \
$rawdata/$reverse \
$output/E745-1_output_forward_paired.fastq.gz \
$output/E745-1_output_forward_unpaired.fastq.gz \
$output/E745-1_output_reverse_paired.fastq.gz \
$output/E745-1_output_reverse_unpaired.fastq.gz \
ILLUMINACLIP:/sw/arch/eb/software/Trimmomatic/0.39-Java-17/adapters/TruSeq3-PE.fa:2:30:10 \
LEADING:3 TRAILING:3 \
SLIDINGWINDOW:4:15 MINLEN:36 > $output/trimmomatic.log 2>&1
