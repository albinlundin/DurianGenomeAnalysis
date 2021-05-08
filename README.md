# DurianGenomeAnalysis
my_project.md contains the project plan.

## Pipeline
1. The script 01_pacbio_assembly.sh (in code/01_canu_assembly/) was used to generate a genome alignment of the pacbio reads using canu. The output assembly was obtained in a fasta file.
2. FastQ was used to check the quality of the provided (and trimmed) illumina reads. This was done through the FastQC gui so there is no script for this step.
3. The script 02_bwa_alignment.sh (in code/02_bwa_pacbio_illumina/) was used to align the illumina reads to the pacbio assembly using bwa. The output was obtained in a sam file. 
4. To convert the obtained sam file to a bam file the following command was used: 
```bash
samtools view -S -b pacbio_illumina_alignment.sam > pacbio_illumina_alignment.bam
```
4. The script 03_pilon_polishing.sh (in code/03_pilon_polishing) was used to improve the pacbio assembly using the bam file from step 3. This script also sorted and index the bam file using samtools.
5. To check the quality of the polished assembly quast was used (see code/04_quast_quality). 
6. To softmask the pilon polished genome RepeatMasker was used as seen in the script "code/05_repeatmasker/05_repeatmasker.sh". The reference genome produced by the authors of paper 5 was also softmasked using the script "code/05_repeatmasker/reference_repeatmasker.sh". These scripts are essentially the same, only differing in the inputs. 
7. As an extra quality check of the polished assembly, mummer was used as seen below. The resulting PNG of the multiplot can be found in "resutls/mummer/". Kepp in mind that the script in code/06_mummer does not work, and the code below was run directly on the command line.
```bash
module load bioinfo-tools
module load MUMmer/4.0.0rc1
nucmer /home/allu5328/Documents/genome_analysis/project/Data/Reference_sequences/reference_sequence_scaffold_11.fasta \ 
/home/allu5328/Documents/genome_analysis/project/Data/04_pilon_polishing/pilon.fasta > nucmer_out.txt
delta-filter -q out.delta > out.delta.filter
mummerplot -p multiplot_filtered -l --png out.delta.filter
mummerplot -p filtered --png out.delta.filter
```
8. Trimmomatic was used to trimm the two untrimmed provided RNA sequence files, as seen in the script at code/07_trimmomatic. 
9. Star was used to map all trimmed RNA seq files to the pilon polished, softmasked genome assembly to create a bam file using the script "code/08_star/03_star.sh". To map the trimmed RNA sequences to the softmasked reference genome the script "code/08_star/04_star.sh" was used.
10. BRAKER was used to make a structural annotation of the genome assembly using the bam files produced by star as a hint. I could not get this to work with my assembly, so this was made with the reference assembly using the script "code/09_braker/reference_braker.sh". 
11. To make the gtf file from braker into a protein sequence fasta fila and a gff file these two commands was used:
```bash
/sw/bioinfo/augustus/3.4.0/snowy/scripts/gtf2aa.pl $genome $gtf prot.fa
/sw/bioinfo/augustus/3.4.0/snowy/scripts/gtf2gff.pl <$gtf --out=augustus.gff
```
where $genome is the path to the softmasked reference genome and $gtf the path to the gtf file produced by braker.

12. The file prot.fa was submitted to eggnogmapper using the web interface. All options were kept at their default values.

## Analyses and results
### Quality check of the provided Illumina DNA reads using FastQC
For the provided trimmed Illumina DNA reads the quality looked really good. The phred score was high for all base positions (which can be seen below) and everything else looked alright. 
![image](https://github.com/albinlundin/DurianGenomeAnalysis/blob/main/results/FastQC_DNA_Illumina/Illumina_DNA_Phred.png "Phred score")

### Genome assembly

#### Canu
To make the assembly using Canu, the script at code/01_canu_assembly was used. Apart from doing the actual assembly, Canu also performs correction of the bases as well as trimming of low quality regions. In this script the genomeSize parameter was set to 24 million since that is roughly the length for scaffold 11 in the genome assembly produced by the authors of paper 5. The output report from canu gives some statistics about the assembly:
* 87% of the PacBio reads has an overlap, which is a good thing since most of the reads has an overlap.
* NG50 for the assembly equals 1,121,946 basepairs, meaning that reads of that length or longer makes up 50% of the genome.
* LG50 for the assembly equals to 7 contigs, meaning that 7 contigs makes up the 50% of the genome.
* Total length of the assembly equals 31.5 million base pairs. 
* Number of contigs in the assembly is 745.

My assembly is quite a bit longer compared to the one produced by the authors of paper 5, being approximately 30% longer. My assembly also consists of many contigs which does not look so good since a lower number of contigs is preferrable. However, I am quite satisfied with the LG50 and NG50 values since the LG50 value is low meaning that I do have some long contigs. Notice that these two values are in relation to the genomeSize parameter that was specified in the script to 24 million bases, and not to the total length of the assembly. 

#### BWA
To align the paired end Illumina reads to the canu assembled genome bwa was used according to the script at code/02_bwa_pacbio_illumina/. Here I used the commands bwa aln and bwa sampe, which generates alignments given paired-end data. However, now I am under the impression that bwa mem would have been a better choice for the alignment due to it being more accurate, according to the bwa manual. 

#### Pilon
To improve the canu assembly pilon was used according to the script located at code/03_pilon_polishing/. There are not many choices to be made here, or any outputed statistics so there is not much to discuss about this. 

#### RepeatMasker
To mask the assembly for repetetive sequences, repeatmasker was used according to the script at code/05_repeatmasker/. The used option '-xsmall' softmasks the genome. 2.68% of the assembly consisted of simple repeats, 1.1% of the genome had low complexity, and the GC level was measured to 30.6%. 

#### Questions from the Student manual
- What information can you get from the plots and reports given by the assembler (if you get any)?
- What intermediate steps generate informative output about the assembly?
- How many contigs do you expect? How many do you obtain?

I got 745 contigs in my assembly of scaffold 11. I think the expected number of contigs is 70, since the authors of paper 5 had 69 assembly gaps when assembling scaffold 11. In that case I clearly have more.
- What is the difference between a ‘contig’ and a ‘unitig’?
- What is the difference between a ‘contig’ and a ‘scaffold’?

A contig is a DNA sequence without any gaps. A scaffold is an arrangement of multiple contigs in the same order as they would be in the genome. A scaffold do contain gaps, a contig does not. 
- What are the k-mers? What k-mer(s) should you use? What are the problems and benefits of choosing a small kmer? And a big k-mer?

K-mers are sequences present in the genome. For instance 5-mers are all possible sequences you can get of length 5. K-mers are used in assembly to see which reads are overlapping. If you choose a small k-mer you will have many overlaps for the reads, but it will increase computation time and coudl make it harder to assemble. If using a large k-mer you will have less overlaps between the reads, which might make the assembly easier to perform, but if using a to large k-mer you could miss some overlaps between reads.
- Some assemblers can include a read-correction step before doing the assembly. What is this step doing?
- How different do different assemblers perform for the same data?
- Can you see any other letter appart from AGTC in your assembly? If so, what are those?

### Quality assessment of genome assembly
#### QUAST
To check the quality of the assembly, QUAST was used according to the script at "code/04_quast_quality". The full statistic output produced by QUAST can be seen in the html file "report.html" located at "results/quast/". Following is a summary of the statistcs presented there: 
* Duplication ratio	1.229
* Largest alignment	1,421,498
* NG50	1,122,122
* NG75	305,427
* NGA50	315,796
* LG50	7
* LG75	19
* LGA50	21
* Misassemblies	258 (with 255 relocations and 3 inversions)
* Misassembled contigs	126 (number of contigs with missassembly events)
* Fully unaligned contigs	189
* Fully unaligned length	2,067,295
* Contigs in assembly	898
* Largest contig	2,660,159

A duplication ratio larger than 1 is quite expected considering that the total length of my assembly is 31.5 million bases, while the reference assembly roughly is 24 million bases. This happens because the assembly has multiple contigs covering the same part of the reference, which could happen if the assembly overestimates how many times a certain repeat sequence appears in a repeat region. Of course, this is something that could be improved during the assembly.

The largest assembly being 1,421,498 bases long I consider as quite good. The highest score this assembly could acheive on this metric is 2,660,159 bases which is the same as the largest contig length. The fact that these two metrics are not the same indicates that there is at least one missassembly event in the largest contig in the assembly, which is also something that could be improved. 

I consider a NG50 value of 1,122,122 and a LG50 value of 7 to be quite good, indicating that most of my assembly is consisting of long contigs and that only 7 contigs in the assembly is needed for covering 50% of the reference. If looking at a slight larger part of the reference genome the NG75 value is 305,427 bases and the LG75 value is 19, which I also consider to be good values. However, something yet again indicating missassemblies in these long contigs are the NGA50 and LGA50 values (being 315,796 and 21 respectively), taking a significant drop compared to the NG50 and LG50 values. 

Overall, there were 258 missassemblies detected by QUAST which I think is quite high and definitely something that could be improved. The total number of contigs having missassemblies being 126 is something that indicates that the missassemblies is spread accross a quite large fraction of the contigs and not just confined to a few of the contigs, which would have been preferred. 

There were also quite a few fully unaligned contigs, being 189 in total, taking up a significant fraction of the total number of contigs in the assembly. However, since their combined length is 2,067,295 it means that the average length of these contigs is roughly 11,000 bases which is not very long compared to some of the other contigs produced, and therefor maybe not as good anyway. 

To conclude the QUAST quality assessment, I think that the metrics look quite good apart from the apparent missassemblies. 

#### MUMmerplot
As an extra quality check of the genome assembly, mummerplot was used (or more specific nucmer and mummerplot) as described in this readme document. (Note that the script at "code/mummer/" does not work). The following image (which can also be found at "results/mummer/") shows the multiplot produced by mummer:
![image](https://github.com/albinlundin/DurianGenomeAnalysis/blob/main/results/mummer/multiplot_filtered.png "Mummer multiplot")

In this plot it is quite obvious that the assembly is quite a bit longer than reference sequence, but the continuous, red, diagonal line indicates that the content of the assembly is coherent with the reference, even if it consists of quite a few more contigs.



