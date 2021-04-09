#!/bin/bash -l
#SBATCH -A g2021012
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 20:00:00
#SBATCH -J 01_canu_assembly
#SBATCH --mail-type=ALL
#SBATCH --mail-user albin.lundin.5328@student.uu.se

# Load modules
module load bioinfo-tools
module load canu/2.0

canu -p 01_canuassembly -d /home/allu5328/Documents/genome_analysis/project/Analyses/canu_assembly/01_canu_assembly genomeSize=800m \
-pacbio-raw /home/allu5328/Documents/genome_analysis/project/Data/RawData/pacbio/SRR6037732_scaffold_11.fq.gz 
