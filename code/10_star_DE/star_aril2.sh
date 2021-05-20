#!/bin/bash -l
#SBATCH -A g2021012
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 00:15:00
#SBATCH -J star_mapping
#SBATCH --mail-type=ALL
#SBATCH --mail-user albin.lundin.5328@student.uu.se

module load bioinfo-tools
module load star/2.7.2b

genomeDir="/home/allu5328/Documents/genome_analysis/project/Analyses/14_star_DE/genomeDir/"

cd /home/allu5328/Documents/genome_analysis/project/Analyses/14_star_DE/

aril1="/home/allu5328/Documents/genome_analysis/project/Data/RawData/transcripts/trimmed/aril_SRR6040097_scaffold_11.1.fastq.gz"
aril2="/home/allu5328/Documents/genome_analysis/project/Data/RawData/transcripts/trimmed/aril_SRR6040097_scaffold_11.2.fastq.gz"

STAR --runThreadN 8 \
--genomeDir $genomeDir \
--readFilesCommand gunzip -c \
--readFilesIn $aril1 $aril2 \
--outFileNamePrefix aril_097 \
--outSAMtype BAM SortedByCoordinate \
--limitBAMsortRAM 2053908829
