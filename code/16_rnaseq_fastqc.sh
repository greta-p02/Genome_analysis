#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -n 2
#SBATCH -J job_fastqc
#SBATCH -t 00:30:00

module load FastQC/0.12.1-Java-17


rawdataBH=/proj/uppmax2026-1-61/Genome_Analysis/1_Zhang_2017/transcriptomics_data/RNA-Seq_BH/raw/*.fastq.gz
rawdataSerum=/proj/uppmax2026-1-61/Genome_Analysis/1_Zhang_2017/transcriptomics_data/RNA-Seq_Serum/raw/*.fastq.gz
outputBH=/home/gretap/Genome_analysis/results/12_rnaseq_raw_qc/BH
outputSerum=/home/gretap/Genome_analysis/results/12_rnaseq_raw_qc/serum

for file in $rawdataBH
do
fastqc --threads 2 $file -o $outputBH
done


for file in $rawdataSerum
do
fastqc --threads 2 $file -o $outputSerum
done
