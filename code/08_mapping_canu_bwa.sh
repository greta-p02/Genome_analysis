#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -J job_mapping_canu
#SBATCH -t 02:00:00
#SBATCH --output=%x.%j.out

module load BWA/0.7.19-GCCcore-13.3.0 SAMtools/1.22.1-GCC-13.3.0


assemblycanu=/home/gretap/Genome_analysis/data/genome_assemblies/efaecium_pacbio_assembly.contigs.fasta
output=/home/gretap/Genome_analysis/results/05_mapping_illumina_to_canu
illumina1=/home/gretap/Genome_analysis/data/raw_illumina/Illumina_clean_R1.fq.gz
illumina2=/home/gretap/Genome_analysis/data/raw_illumina/Illumina_clean_R2.fq.gz


bwa index $assemblycanu

bwa mem \
$assemblycanu $illumina1 $illumina2 -t 2 | samtools sort -@ 2 -o $output/canu_sorted.bam

samtools index -@ 2 $output/canu_sorted.bam





