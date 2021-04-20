#!/bin/bash -l
#SBATCH -A g2021012
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 02:00:00
#SBATCH -J quast_quality_check
#SBATCH --mail-type=ALL
#SBATCH --mail-user albin.lundin.5328@student.uu.se

module load bioinfo-tools
module load quast/5.0.2

outdir="/home/allu5328/Documents/genome_analysis/project/Analyses/05_quast_quality/"
assembly="/home/allu5328/Documents/genome_analysis/project/Data/04_pilon_polishing/pilon.fasta"
reference="/home/allu5328/Documents/genome_analysis/project/Data/Reference_sequences/reference_sequence_scaffold_11.fasta.gz"

quast.py -o $outdir -r $reference $assembly
