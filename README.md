# DurianGenomeAnalysis
my_project.md contains the project plan.

## Pipeline
1. The script 01_pacbio_assembly.sh (in code/01_canu_assembly/) was used to generate a genome alignment of the pacbio reads using canu. The output assembly was obtained in a fasta file.
2. The script 02_bwa_alignment.sh (in code/02_bwa_pacbio_illumina/) was used to align the trimmed (provided) illumina reads to the pacbio assembly using bwa. The output was obtained in a sam file. 
3. To convert the obtained sam file to a bam file the following command was used: 
```bash
samtools view -S -b pacbio_illumina_alignment.sam > pacbio_illumina_alignment.bam
```
4. The script 03_pilon_polishing.sh (in code/03_pilon_polishing) was used to improve the pacbio assembly using the bam file from step 3.
