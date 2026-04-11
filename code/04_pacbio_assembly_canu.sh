#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 4
#SBATCH -J job_pacbio_assembly
#SBATCH -t 10:00:00
#SBATCH --mail-type=ALL
#SBATCH --output=%x.%j.out

module load SAMtools/1.22.1-GCC-13.3.0
module load canu/2.3-GCCcore-13.3.0-Java-17


rawdata=/proj/uppmax2026-1-61/Genome_Analysis/1_Zhang_2017/genomics_data/PacBio/*
output=/home/gretap/Genome_analysis/results/02_genome_assembly_pacbio


canu \
-p efaecium_pacbio_assembly \
-d $output \
genomeSize=3m \
maxThreads=4 \
useGrid=false \
-pacbio $rawdata \
1>canu-assembly.stdout \
2>canu-assembly.stderr

