#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -J job_busco
#SBATCH -t 00:15:00
#SBATCH --output=%x.%j.out

module load BUSCO/5.8.2-gfbf-2024a


assemblycanu=/home/gretap/Genome_analysis/data/polished_canu/1_pilon_canu.fasta
assemblyspades=/home/gretap/Genome_analysis/data/genome_assemblies/efaecium_spades_assembly.fasta
output=/home/gretap/Genome_analysis/results/07_post_polishing_qc/02_canu_spades_busco
reference=/home/gretap/Genome_analysis/data/reference_assembly/efaecium_reference_assembly.fna

busco \
-i $assemblycanu \
-c 2 \
-m genome \
-l firmicutes_odb10 \
-o canu_f \
--out_path $output

busco \
-i $assemblyspades \
-c 2 \
-m genome \
-l firmicutes_odb10 \
-o spades_f \
--out_path $output
