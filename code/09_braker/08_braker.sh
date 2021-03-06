#!/bin/bash -l
#SBATCH -A g2021012
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 02:00:00
#SBATCH -J braker_annotation
#SBATCH --mail-type=ALL
#SBATCH --mail-user albin.lundin.5328@student.uu.se

#load modules
module load bioinfo-tools
module load perl/5.24.1
module load braker/2.1.1_Perl5.24.1
module load augustus/3.2.3_Perl5.24.1
module load bamtools/2.5.1
module load blast/2.9.0+
module load GenomeThreader/1.7.0
module load samtools/1.8
module load GeneMark/4.33-es_Perl5.24.1
#module load GeneMark/4.62-es

#flags
export AUGUSTUS_CONFIG_PATH=/home/allu5328/Documents/genome_analysis/augustus_config
export AUGUSTUS_BIN_PATH=/sw/bioinfo/augustus/3.4.0/snowy/bin
export AUGUSTUS_SCRIPTS_PATH=/sw/bioinfo/augustus/3.4.0/snowy/scripts
export GENEMARK_PATH=/sw/bioinfo/GeneMark/4.33-es/snowy


genome="/home/allu5328/Documents/genome_analysis/project/Data/05_repeatmasker/pilon.fasta.masked.gz"
alignment="/home/allu5328/Documents/genome_analysis/project/Data/07_star_before_braker/Aligned.sortedByCoord.out.bam"

cd /home/allu5328/Documents/genome_analysis/project/Analyses/12_braker/

braker.pl --cores=2 --softmasking --species=Durian --useexisting --genome=$genome --bam=$alignment --min_contig=10000 \
--AUGUSTUS_CONFIG_PATH=/home/allu5328/Documents/genome_analysis/augustus_config \
--AUGUSTUS_BIN_PATH=/sw/bioinfo/augustus/3.4.0/snowy/bin \
--AUGUSTUS_SCRIPTS_PATH=/sw/bioinfo/augustus/3.4.0/snowy/scripts \
--GENEMARK_PATH=/sw/bioinfo/GeneMark/4.33-es/snowy
