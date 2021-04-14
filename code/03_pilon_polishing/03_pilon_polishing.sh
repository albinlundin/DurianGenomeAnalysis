#!/bin/bash -l
#SBATCH -A g2021012
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 01:00:00
#SBATCH -J pilon_polishing
#SBATCH --mail-type=ALL
#SBATCH --mail-user albin.lundin.5328@student.uu.se

# Polish the canu pacbio assembly using pilon

#Load modules
module load bioinfo-tools
module load Pilon/1.24
module load samtools/1.10

cd /home/allu5328/Documents/genome_analysis/project/Data/03_bwa_alignment

samtools sort -o pacbio_illumina_alignment_sorted.bam pacbio_illumina_alignment.bam
samtools index pacbio_illumina_alignment_sorted.bam

canu_assembly="/home/allu5328/Documents/genome_analysis/project/Data/02_Assembly/canu_assembly/01_canuassembly.contigs.fasta.gz"
bam_file="/home/allu5328/Documents/genome_analysis/project/Data/03_bwa_alignment/pacbio_illumina_alignment_sorted.bam"
pilon="java -jar $PILON_HOME/pilon.jar"

cd /home/allu5328/Documents/genome_analysis/project/Analyses/04_pilon_polishing

$pilon --genome $canu_assembly --frags $bam_file


