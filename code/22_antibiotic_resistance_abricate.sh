#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -n 2
#SBATCH -J job_abricate
#SBATCH -t 2:00:00
#SBATCH --output=%x.%j.out

module load eggnog-mapper/2.1.13-gfbf-2024a

canu=/home/gretap/Genome_analysis/data/polished_canu/1_pilon_canu.fasta
output=/home/gretap/Genome_analysis/results/18_antibiotic_resistance


abricate $canu > $output/AMR_out.tsv




