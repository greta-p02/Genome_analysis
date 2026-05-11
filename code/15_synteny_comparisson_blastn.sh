#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -n 1
#SBATCH -J job_blastn
#SBATCH -t 00:10:00
#SBATCH --output=%x.%j.out

module load BLAST+/2.17.0-gompi-2024a


assemblycanu=/home/gretap/Genome_analysis/data/polished_canu/1_pilon_canu.fasta
close_reference=/home/gretap/Genome_analysis/data/reference_assembly/efaecium_reference_assembly.fna
output=/home/gretap/Genome_analysis/results/11_synteny_comparisson

makeblastdb -in $assemblycanu -dbtype nucl
makeblastdb -in $close_reference -dbtype nucl

blastn -outfmt 6 \
-db $close_reference \
-query $assemblycanu \
-out $output/blast_results.tab


