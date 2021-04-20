#!/bin/bash -l
#SBATCH -A g2021012
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 05:00:00
#SBATCH -J repeatmasker_masking
#SBATCH --mail-type=ALL
#SBATCH --mail-user albin.lundin.5328@student.uu.se

# Mask the pilon polished assembly

#Load modules
module load bioinfo-tools
module load RepeatMasker/4.1.0

assembly="/home/allu5328/Documents/genome_analysis/project/Data/04_pilon_polishing/pilon.fasta"
outdir="/home/allu5328/Documents/genome_analysis/project/Analyses/06_repeatmasker"

RepeatMasker -dir $outdir -xsmall $assembly
