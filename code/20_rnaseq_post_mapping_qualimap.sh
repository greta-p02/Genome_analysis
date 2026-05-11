#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -J job_qualimap
#SBATCH -t 02:00:00
#SBATCH --output=%x.%j.out

module load Qualimap/2.3-foss-2024a-R-4.4.2


output_bh=/home/gretap/Genome_analysis/results/16_rnaseq_post_mapping_qc/BH
output_serum=/home/gretap/Genome_analysis/results/16_rnaseq_post_mapping_qc/serum
sorted_bh=/home/gretap/Genome_analysis/results/15_rnaseq_mapping/BH/*_sorted.bam
sorted_serum=/home/gretap/Genome_analysis/results/15_rnaseq_mapping/serum/*_sorted.bam

for file in $sorted_bh
do

name=$(basename "$file" _sorted.bam)

qualimap bamqc \
-bam $file \
-outdir $output_bh/${name}_qualimap

done



for file in $sorted_serum
do

name=$(basename "$file" _sorted.bam)

qualimap bamqc \
-bam $file \
-outdir $output_serum/${name}_qualimap

done


