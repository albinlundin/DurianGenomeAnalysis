#!/bin/bash -l
#SBATCH -A g2021012
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 08:00:00
#SBATCH -J htseq-count
#SBATCH --mail-type=ALL
#SBATCH --mail-user albin.lundin.5328@student.uu.se

module load bioinfo-tools
module load htseq/0.12.4
module load samtools/1.12

gtf="/home/allu5328/Documents/genome_analysis/project/Data/08_braker/augustus.hints_removed.gtf"
root="/home/allu5328/Documents/genome_analysis/project/Data/10_starDE/root_093Aligned.sortedByCoord.out.bam"

cd /home/allu5328/Documents/genome_analysis/project/Analyses/15_htseq

htseq-count -r pos -f bam $root $gtf > root_093.txt

