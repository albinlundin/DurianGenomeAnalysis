#!/bin/bash -l
#SBATCH -A g2021012
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 02:00:00
#SBATCH -J bwa_alignment
#SBATCH --mail-type=ALL
#SBATCH --mail-user albin.lundin.5328@student.uu.se

# Align the PacBio assembly by canu with the trimmed Illumina reads

#Load modules
module load bioinfo-tools
module load bwa/0.17.7

canu_assembly="/home/allu5328/Documents/genome_analysis/project/Data/02_Assembly/canu_assembly/01_canuassembly.contigs.fasta.gz"
illumina_1="/home/allu5328/Documents/genome_analysis/project/Data/RawData/illumina/SRR6058604_scaffold_11.1P.fastq.gz"
illumina_2="/home/allu5328/Documents/genome_analysis/project/Data/RawData/illumina/SRR6058604_scaffold_11.2P.fastq.gz"

cd /home/allu5328/Documents/genome_analysis/project/Analyses/03_bwa_alignment

bwa index $canu_assembly
bwa aln $canu_assembly $illumina_1 > aln_illumina1.sai
bwa aln $canu_assembly $illumina_2 > aln_illumina2.sai
bwa sampe $canu_assembly aln_illumina1.sai aln_illumina2.sai $illumina_1 $illumina_2 > pacbio_illumina_alignment.sam

