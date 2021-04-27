#!/bin/bash -l
#SBATCH -A g2021012
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 05:00:00
#SBATCH -J braker_annotation
#SBATCH --mail-type=ALL
#SBATCH --mail-user albin.lundin.5328@student.uu.se

#load modules
module load bioinfo-tools
module load braker/2.1.5-20210115-e98b812

genome="/home/allu5328/Documents/genome_analysis/project/Data/05_repeatmasker/pilon.fasta.masked.gz"
export AUGUSTUS_CONFIG_PATH=/home/allu5328/Documents/genome_analysis/augustus_config

cd /home/allu5328/Documents/genome_analysis/project/Analyses/11_braker

braker.pl --softmasking --esmode --genome=$genome
