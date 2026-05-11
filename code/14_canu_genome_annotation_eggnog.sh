#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -n 2
#SBATCH -J job_eggnog
#SBATCH -t 15:00:00
#SBATCH --output=%x.%j.out

module load eggnog-mapper/2.1.13-gfbf-2024a

annotatedcanu=/home/gretap/Genome_analysis/data/annotated_prokka/efaecium_annotate.faa
output=/home/gretap/Genome_analysis/results/10_genome_annotation_polishing
database_dir=/sw/data/uppnex/eggNOG/5.0/rackham

emapper.py \
-i $annotatedcanu \
-o efaecium_eggnog \
--data_dir $database_dir \
--output_dir $output \
--cpu 2 




