#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -J job_htseq
#SBATCH -t 08:00:00
#SBATCH --output=%x.%j.out

module load HTSeq/2.1.2-gfbf-2024a


output=/home/gretap/Genome_analysis/results/17_rnaseq_counts
sorted_bh=/home/gretap/Genome_analysis/results/15_rnaseq_mapping/BH/*_sorted.bam
sorted_serum=/home/gretap/Genome_analysis/results/15_rnaseq_mapping/serum/*_sorted.bam
annotation=/home/gretap/Genome_analysis/data/annotated_prokka/efaecium_annotate_clean.gff



htseq-count \
--format bam \
$sorted_bh $sorted_serum \
$annotation \
-r pos \
-s no \
-t CDS \
-i ID \
> $output/counts_output.txt

