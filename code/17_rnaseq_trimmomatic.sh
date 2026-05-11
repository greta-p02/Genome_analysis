#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -n 2
#SBATCH -J job_trimmomatic
#SBATCH -t 06:00:00
#SBATCH --output=%x.%j.out

module load Trimmomatic/0.39-Java-17


output_bh=/home/gretap/Genome_analysis/results/13_rnaseq_trimmomatic/BH
output_serum=/home/gretap/Genome_analysis/results/13_rnaseq_trimmomatic/serum
forward_bh=/proj/uppmax2026-1-61/Genome_Analysis/1_Zhang_2017/transcriptomics_data/RNA-Seq_BH/raw/*_1.fastq.gz
forward_serum=/proj/uppmax2026-1-61/Genome_Analysis/1_Zhang_2017/transcriptomics_data/RNA-Seq_Serum/raw/*_1.fastq.gz



mkdir $SNIC_TMP/trimmomatic_bh
cd $SNIC_TMP/trimmomatic_bh

for R1 in $forward_bh
do

R2="${R1%_1.fastq.gz}_2.fastq.gz"
name=$(basename "$R1" _1.fastq.gz)

cp "$R1" .
cp "$R2" .

R1_local=$(basename "$R1")
R2_local=$(basename "$R2")

trimmomatic PE -threads 2 -phred33 \
$R1_local \
$R2_local \
${name}_1_paired.fastq.gz \
${name}_1_unpaired.fastq.gz \
${name}_2_paired.fastq.gz \
${name}_2_unpaired.fastq.gz \
ILLUMINACLIP:/sw/arch/eb/software/Trimmomatic/0.39-Java-17/adapters/TruSeq3-PE.fa:2:30:10 \
LEADING:3 TRAILING:3 \
SLIDINGWINDOW:4:15 MINLEN:36

mv ${name}_*_paired.fastq.gz $output_bh/
mv ${name}_*_unpaired.fastq.gz $output_bh/

rm $R1_local $R2_local

done





mkdir $SNIC_TMP/trimmomatic_serum
cd $SNIC_TMP/trimmomatic_serum

for R1 in $forward_serum
do

R2="${R1%_1.fastq.gz}_2.fastq.gz"
name=$(basename "$R1" _1.fastq.gz)

cp "$R1" .
cp "$R2" .

R1_local=$(basename "$R1")
R2_local=$(basename "$R2")

trimmomatic PE -threads 1 -phred33 \
$R1_local \
$R2_local \
${name}_1_paired.fastq.gz \
${name}_1_unpaired.fastq.gz \
${name}_2_paired.fastq.gz \
${name}_2_unpaired.fastq.gz \
ILLUMINACLIP:/sw/arch/eb/software/Trimmomatic/0.39-Java-17/adapters/TruSeq3-PE.fa:2:30:10 \
LEADING:3 TRAILING:3 \
SLIDINGWINDOW:4:15 MINLEN:36

mv ${name}_*_paired.fastq.gz $output_serum/
mv ${name}_*_unpaired.fastq.gz $output_serum/

rm $R1_local $R2_local

done
