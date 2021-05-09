01_canu_assembly contains the code and slurm output for the canu assembly of the pacbio reads. slurm-4409359 is the appropriate slurm output.

02_bwa_pacbio_illumina contains the bwa code for aligning illumina reads with the assmeble pacbio genome.

03_pilon_polishing contains the code for polishing the assembled pacbio genome with the illumina reads.

04_quast_quality contains the script for checking the quality of the polished assembly

05_repeatmasker contains the script for softmasking the polished assembly

06_mummer contains the script for mummer, quality check of the pilon polished assembly

07_trimmomatic contains the script for pre processing the two untrimmed RNA transcripts

08_star contains the script for RNA mapping to the softmasked, pilon polished genome, using all trimmed RNA sequences and the software STAR.
08_star also contain a script for RNA mapping to the assembly produced by the authors of paper 5, which is the only script that ended up working

09_braker contains the script for structural annotation of the pilon polished assembly, using the bam file produced by star as hints.

10_star_DE contains the star script producing the bam/sam files used in the differential expression analysis

11_htseq contains the htseq-count script for counting reads
