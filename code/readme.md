01_canu_assembly contains the code and slurm output for the canu assembly of the pacbio reads. slurm-4409359 is the appropriate slurm output.

02_bwa_pacbio_illumina contains the bwa code for aligning illumina reads with the assmeble pacbio genome.

03_pilon_polishing contains the code for polishing the assembled pacbio genome with the illumina reads.

04_quast_quality contains the script for checking the quality of the polished assembly

05_repeatmasker contains the script for softmasking the polished assembly

06_mummer contains the script for mummer, quality check of the pilon polished assembly

07_trimmomatic contains the script for pre processing the two untrimmed transcripts

08_braker contains the script for structural annotation of the pilon polished assembly
