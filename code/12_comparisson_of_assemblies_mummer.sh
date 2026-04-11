#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -n 2
#SBATCH -J job_mummer
#SBATCH -t 0:15:00
#SBATCH --output=%x.%j.out

module load MUMmer/4.0.1-GCCcore-13.3.0


assemblycanu=/home/gretap/Genome_analysis/data/polished_canu/1_pilon_canu.fasta
assemblyspades=/home/gretap/Genome_analysis/data/genome_assemblies/efaecium_spades_assembly.fasta
assemblyref=/home/gretap/Genome_analysis/data/reference_assembly/efaecium_reference_assembly.fna
output=/home/gretap/Genome_analysis/results/04_post_assembly_qc/03_canu_spades_mummer


cd $output

nucmer \
-p mummer_file_canu_spades \
$assemblycanu \
$assemblyspades 

mummerplot \
--png \
-p mummer_plot_canu_spades \
mummer_file_canu_spades.delta



nucmer \
-p mummer_file_canu_ref \
$assemblyref \
$assemblycanu

mummerplot \
--png \
-p mummer_plot_canu_ref \
mummer_file_canu_ref.delta



nucmer \
-p mummer_file_spades_ref \
$assemblyref \
$assemblyspades

mummerplot \
--png \
-p mummer_plot_spades_ref \
mummer_file_spades_ref.delta
