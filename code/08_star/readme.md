01_star.sh creates a genome index 

02_star.sh makes the rna mapping (the combination of this script with 01_star.sh did not work with braker)

03_star.sh is a new attempt of using star, since braker had some problems with the bam file produced by the scripts 01_star.sh and 02_star.sh. (the output of this script did not work with braker either)

04_star.sh is the script to align the rna sequences to the reference genome produced by the authors of paper 5 (the outputs of this script worked with braker)
