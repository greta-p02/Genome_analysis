#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -n 2
#SBATCH -J job_prokka
#SBATCH -t 01:00:00
#SBATCH --output=%x.%j.out

module load prokka/1.14.5-gompi-2024a barrnap/0.9-gompi-2024a


assemblycanu=/home/gretap/Genome_analysis/data/polished_canu/1_pilon_canu.fasta
output=/home/gretap/Genome_analysis/results/09_genome_annotation


prokka \
$assemblycanu \
--outdir $output --force \
--prefix efaecium_annotate \
--locustag EFAEC \
--genus Enterococcus \
--species faecium \
--usegenus \
--cpus 2



