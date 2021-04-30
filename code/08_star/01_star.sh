#!/bin/bash -l
#SBATCH -A g2021012
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 8
#SBATCH -t 00:15:00
#SBATCH -J braker_annotation
#SBATCH --mail-type=ALL
#SBATCH --mail-user albin.lundin.5328@student.uu.se

module load bioinfo-tools
module load star/2.7.2b

genomeDir="/home/allu5328/Documents/genome_analysis/project/Analyses/11_star/genomeDir/"

cd /home/allu5328/Documents/genome_analysis/project/Analyses/11_star/

STAR --runThreadN 8 \
--runMode genomeGenerate \
--genomeDir $genomeDir \
--genomeFastaFiles /home/allu5328/Documents/genome_analysis/project/Data/05_repeatmasker/pilon.fasta.masked 


