#!/bin/bash -l
#SBATCH -A g2021012
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 02:00:00
#SBATCH -J mummer_quality_check
#SBATCH --mail-type=ALL
#SBATCH --mail-user albin.lundin.5328@student.uu.se

module load bioinfo-tools
module load MUMmer/4.0.0rc1

cd /home/allu5328/Documents/genome_analysis/project/Analyses/07_mummer/
reference="/home/allu5328/Documents/genome_analysis/project/Data/Reference_sequences/reference_sequence_scaffold_11.fasta.gz"
assembly="/home/allu5328/Documents/genome_analysis/project/Data/04_pilon_polishing/pilon.fasta"

mummer -b $reference $assembly > mummer_out.txt

mummerplot mummer_out.txt
