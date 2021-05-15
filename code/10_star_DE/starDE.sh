#!/bin/bash -l
#SBATCH -A g2021012
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 8
#SBATCH -t 00:15:00
#SBATCH -J star_mapping
#SBATCH --mail-type=ALL
#SBATCH --mail-user albin.lundin.5328@student.uu.se

module load bioinfo-tools
module load star/2.7.2b

genomeDir="/home/allu5328/Documents/genome_analysis/project/Analyses/14_star_DE/genomeDir/"
gtf="/home/allu5328/Documents/genome_analysis/project/Data/08_braker/augustus.hints.gtf"

cd /home/allu5328/Documents/genome_analysis/project/Analyses/14_star_DE/

STAR --runThreadN 8 \
--runMode genomeGenerate \
--genomeDir $genomeDir \
--genomeFastaFiles /home/allu5328/Documents/genome_analysis/project/Data/05_repeatmasker/reference/reference_sequence_scaffold_11.fasta.masked \
--genomeSAindexNbases 11 \
--sjdbGTFfile $gtf \
--sjdbOverhang 100

aril1="/home/allu5328/Documents/genome_analysis/project/Data/RawData/transcripts/trimmed/aril_SRR6040094_scaffold_11.1.fastq.gz"
aril2="/home/allu5328/Documents/genome_analysis/project/Data/RawData/transcripts/trimmed/aril_SRR6040094_scaffold_11.2.fastq.gz"

STAR --runThreadN 8 \
--genomeDir $genomeDir \
--readFilesCommand gunzip -c \
--readFilesIn $aril1 $aril2 \
--outFileNamePrefix aril_094 \
--outSAMtype BAM SortedByCoordinate \
--limitBAMsortRAM 2053908829

root1="/home/allu5328/Documents/genome_analysis/project/Data/RawData/transcripts/trimmed/root_SRR6040093_scaffold_11.1.fastq.gz"
root2="/home/allu5328/Documents/genome_analysis/project/Data/RawData/transcripts/trimmed/root_SRR6040093_scaffold_11.2.fastq.gz"

STAR --runThreadN 8 \
--genomeDir $genomeDir \
--readFilesCommand gunzip -c \
--readFilesIn $root1 $root2 \
--outFileNamePrefix root_093 \
--outSAMtype BAM SortedByCoordinate \
--limitBAMsortRAM 2053908829
