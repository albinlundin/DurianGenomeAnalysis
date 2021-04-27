#!/bin/bash -l
#SBATCH -A g2021012
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 01:00:00
#SBATCH -J trimmomatic_preprocessing
#SBATCH --mail-type=ALL
#SBATCH --mail-user albin.lundin.5328@student.uu.se

# files
forward="/home/allu5328/Documents/genome_analysis/project/Data/RawData/transcripts/untrimmed/SRR6040095_scaffold_11.1.fastq.gz"
reverse="/home/allu5328/Documents/genome_analysis/project/Data/RawData/transcripts/untrimmed/SRR6040095_scaffold_11.2.fastq.gz"

#load modules
module load bioinfo-tools
module load trimmomatic/0.36

cd /home/allu5328/Documents/genome_analysis/project/Analyses/09_trimmomatic

java -jar $TRIMMOMATIC_HOME/trimmomatic.jar PE -threads 2 $forward $reverse SRR6040095_scaffold_11.1P.fastq.gz \
SRR6040095_scaffold_11.1U.fastq.gz SRR6040095_scaffold_11.2P.fastq.gz SRR6040095_scaffold_11.2U.fastq.gz \
ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 TRAILING:20
