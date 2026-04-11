#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -J job_polishing_canu
#SBATCH -t 02:00:00
#SBATCH --output=%x.%j.out

module load Pilon/1.24-Java-17


assemblycanu=/home/gretap/Genome_analysis/data/genome_assemblies/efaecium_pacbio_assembly.contigs.fasta
bamfile=/home/gretap/Genome_analysis/results/05_mapping_illumina_to_canu/canu_sorted.bam
output=/home/gretap/Genome_analysis/results/06_polishing_pacbio/first_run


pilon \
--genome $assemblycanu \
--frags $bamfile \
--output 1_pilon_canu \
--outdir $output \
--changes \
--tracks \
--threads 2





