#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -n 2
#SBATCH -J job_quast
#SBATCH -t 0:15:00
#SBATCH --output=%x.%j.out

module load QUAST/5.3.0-gfbf-2024a


assemblycanu=/home/gretap/Genome_analysis/data/polished_canu/1_pilon_canu.fasta
assemblyspades=/home/gretap/Genome_analysis/data/genome_assemblies/efaecium_spades_assembly.fasta
output=/home/gretap/Genome_analysis/results/07_post_polishing_qc/01_canu_spades_quast
reference=/home/gretap/Genome_analysis/data/reference_assembly/efaecium_reference_assembly.fna

quast.py \
$assemblycanu \
$assemblyspades \
--labels Canu,SPAdes \
-r $reference \
--threads 2 \
-o $output

