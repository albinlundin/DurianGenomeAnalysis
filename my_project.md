# Project Plan
## Aim, analyses and softwares
The aim of this project is to partially reproduce the results from the paper "The draft genome of tropical fruit durian (Durio zibethinus)" by Bin Tean Teh et al. To reproduce these results a number of analyses and softwares will be used. To make the genome assembly based on the PacBio long-reads the software Canu will be used. In addition to performing the actual assembly, this software will also be used to perform a quality control of the PacBio reads and to preprocess them (meaning that the reads will be trimmed). This analysis will act a bit as a time bottleneck considering it needs approximately 17 hours to run. 

To further improve the genome assembly, Illumina short reads will be used to correct the PacBio assembly. Similarly to the PacBio reads, the quality of the illumina reads will be assesed as well as preprocessed. To asses the quality of the Illumina reads the software FastQC will be used, and to preprocess (or trim the reads) the software Trimmomatic will be used. Neither of these softwares is assumed to be a time bottleneck. The software Pilon will be used to correct the PacBio reads using the processed Illumina reads while the software RepeatMasker will be used to detect and mask repeats in the assembly. To use the software Pilon, it is required that the Illumina reads are aligned to the PacBio assembly. For this purpose the software BWA will be used.

For assessing the quality of the genome assembly the software QUAST will be used. The software BRAKER will be used to make a structural annotation of the genome and when running this software it is important that repeats in the assembly are masked (which is done with the software RepeatMasker), preferably softmasked. For performing a functional annotation the software eggNOGmapper will be used.   

In this project a differential expression analysis will also be performed. To do this, the software STAR will be used to align RNA sequences from multiple cultivars to a reference (I guess the reference in this case would be the produced genome assembly). Then HTSeq will be used for counting how many reads that maps to each feature and DESeq2 to compare the expression levels between cultivars. 

An overview of the analyses, as well as their inputs and outputs can be seen in the following image:
![alt text](https://github.com/albinlundin/DurianGenomeAnalysis/blob/main/images/ProjectPlan_new.png "Project plan")

## Timeframe
To make sure this project progresses as it should, I have set up a few preliminary time checkpoints as seen below:
* By 9th of april the goal is to submit a Canu job to Uppmax. 
* By 15th of april the goal is to be finished with the genome assembly. This includes assembling the PacBio reads using Canu, to correct the PacBio assembly using Pilon and to mask repeats using RepeatMasker. 
* By 23rd of april the goal is to be finsihed with the genome annotation, both the functional and structural. 
* By 3rd of May the goal is to be finished with the mapping of RNA sequences using STAR.
* By 11th of May the differential expression analysis should be finished.

I do not know exactly how long time I need to start each analysis, but if it takes longer to get started with some analyses or if errors occur it is possible for the timeframe to be extended.

## Data organization
I will handle various types of data, including fasta and fastq file with sequence information, SAM and BAM files with alignment information, tables with expression analysis data, and various output files from the different analyses. It is hard to know how much disk space is required to store all this data, but all data files will be kept compressed for as long as possible.

All files will be kept in my project folder in Uppmax. The project folder contains this github repository, as well as a folder for all data. The data will not be included in the github repository. The data folder will have separate folders for each kind of data, e.g. Metadata, Raw data, Assemblys, and Alignments. In the github repository there will be a folder for all scripts, and they will be numbered and have informative names to easier get an overview in which order they were made and to what purpose.

# Daily log
## Week 1
* 9th of april - Tried out Canu on uppmax and submitted the Canu batch job "01.pacbio_assembly.sh" to snowy (located at code/canu_assembly/) to assemble the pacbio reads of scaffold 11. The submitted canu batch job did not work with -num_threads in the Canu command, so tried without it whereafter it complained for too low read coverage. Do not know how to proceed at the moment, if I should lower the coverage parameters or if I might have the wrong genome size specified in the canu command (currently I have set the genome size to 800m as estimated in the paper). 
Also used FastQC to perform quality assessment of the illumina reads for scaffold 11. The 1P and 2P files worked but not the 1U and 2U, I do not know whats the difference between them.

## Week 2
* 12th of april - Resubmitted the canu script using 24m as genome size, now it seems to be working.
* 13th of april - Looked into how to use Trimmomatic, BWA and Pilon
* 14th of april - Made alignment of illumina reads to PacBio assembly using BWA. Improved the assembly using Pilon.
* 15th of april - Made quality assesment of the assembly using quast, and softmasked the assembly using repeatmasker.

## Week 3
* 20th of april - Made quality assesment using mummerplot of my assembly
* 22nd of april - Made quality assessments of the untrimmed rna reads that should be used for the functional annotation and expression analysis. Look slightly into how to use trimmomatic


