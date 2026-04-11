#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -J job_spades_assembly
#SBATCH -t 10:00:00
#SBATCH --mail-type=ALL
#SBATCH --output=%x.%j.out

module load SPAdes/4.2.0-GCC-13.3.0


rawdata_nan=/proj/uppmax2026-1-61/Genome_Analysis/1_Zhang_2017/genomics_data/Nanopore/*.fasta.gz
rawdata_il1=/proj/uppmax2026-1-61/Genome_Analysis/1_Zhang_2017/genomics_data/Illumina/E745-1.L500_SZAXPI015146-56_1_clean.fq.gz
rawdata_il2=/proj/uppmax2026-1-61/Genome_Analysis/1_Zhang_2017/genomics_data/Illumina/E745-1.L500_SZAXPI015146-56_2_clean.fq.gz
output=/home/gretap/Genome_analysis/results/03_genome_assembly_nanopore_illumina


spades.py \
-t 2 \
-1 $rawdata_il1 \
-2 $rawdata_il2 \
--nanopore $rawdata_nan \
-o $output
