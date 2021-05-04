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

genomeDir="/home/allu5328/Documents/genome_analysis/project/Analyses/11_star/reference_genome_mapping/genomeDir/"

cd /home/allu5328/Documents/genome_analysis/project/Analyses/11_star/reference_genome_mapping

STAR --runThreadN 8 \
--runMode genomeGenerate \
--genomeDir $genomeDir \
--genomeFastaFiles /home/allu5328/Documents/genome_analysis/project/Data/05_repeatmasker/reference/reference_sequence_scaffold_11.fasta.masked \
--genomeSAindexNbases 9

T92_1="/home/allu5328/Documents/genome_analysis/project/Data/RawData/transcripts/trimmed/SRR6040092_scaffold_11.1.fastq.gz"
T92_2="/home/allu5328/Documents/genome_analysis/project/Data/RawData/transcripts/trimmed/SRR6040092_scaffold_11.2.fastq.gz"
T93_1="/home/allu5328/Documents/genome_analysis/project/Data/RawData/transcripts/trimmed/SRR6040093_scaffold_11.1.fastq.gz"
T93_2="/home/allu5328/Documents/genome_analysis/project/Data/RawData/transcripts/trimmed/SRR6040093_scaffold_11.2.fastq.gz"
T94_1="/home/allu5328/Documents/genome_analysis/project/Data/RawData/transcripts/trimmed/SRR6040094_scaffold_11.1.fastq.gz"
T94_2="/home/allu5328/Documents/genome_analysis/project/Data/RawData/transcripts/trimmed/SRR6040094_scaffold_11.2.fastq.gz"
T95_1="/home/allu5328/Documents/genome_analysis/project/Data/RawData/transcripts/trimmed/SRR6040095_scaffold_11.1P.fastq.gz"
T95_2="/home/allu5328/Documents/genome_analysis/project/Data/RawData/transcripts/trimmed/SRR6040095_scaffold_11.2P.fastq.gz"
T96_1="/home/allu5328/Documents/genome_analysis/project/Data/RawData/transcripts/trimmed/SRR6040096_scaffold_11.1.fastq.gz"
T96_2="/home/allu5328/Documents/genome_analysis/project/Data/RawData/transcripts/trimmed/SRR6040096_scaffold_11.2.fastq.gz"
T97_1="/home/allu5328/Documents/genome_analysis/project/Data/RawData/transcripts/trimmed/SRR6040097_scaffold_11.1.fastq.gz"
T97_2="/home/allu5328/Documents/genome_analysis/project/Data/RawData/transcripts/trimmed/SRR6040097_scaffold_11.2.fastq.gz"
T66_1="/home/allu5328/Documents/genome_analysis/project/Data/RawData/transcripts/trimmed/SRR6156066_scaffold_11.1.fastq.gz"
T66_2="/home/allu5328/Documents/genome_analysis/project/Data/RawData/transcripts/trimmed/SRR6156066_scaffold_11.2.fastq.gz"
T67_1="/home/allu5328/Documents/genome_analysis/project/Data/RawData/transcripts/trimmed/SRR6156067_scaffold_11.1.fastq.gz"
T67_2="/home/allu5328/Documents/genome_analysis/project/Data/RawData/transcripts/trimmed/SRR6156067_scaffold_11.2.fastq.gz"
T69_1="/home/allu5328/Documents/genome_analysis/project/Data/RawData/transcripts/trimmed/SRR6156069_scaffold_11.1.fastq.gz"
T69_2="/home/allu5328/Documents/genome_analysis/project/Data/RawData/transcripts/trimmed/SRR6156069_scaffold_11.2.fastq.gz"

STAR --runThreadN 8 \
--genomeDir $genomeDir \
--readFilesCommand gunzip -c \
--readFilesIn $T92_1,$T93_1,$T94_1,$T95_1,$T96_1,$T97_1,$T66_1,$T67_1,$T69_1 \
$T92_2,$T93_2,$T94_2,$T95_2,$T96_2,$T97_2,$T66_2,$T67_2,$T69_2 \
--outSAMtype BAM SortedByCoordinate \
--limitBAMsortRAM 2053908829