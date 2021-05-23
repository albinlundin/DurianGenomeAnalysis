# DurianGenomeAnalysis
my_project.md contains the project plan.

## Pipeline
The following steps were performed to assemble the genome of the durian cultivar Musang King, and to make an expression analysis comparing the expression levels between root and fruit aril of the cultivar.

1. The script 01_pacbio_assembly.sh (in code/01_canu_assembly/) was used to generate a genome alignment of the pacbio reads using canu. The output assembly was obtained in a fasta file.
2. FastQC was used to check the quality of the provided (and trimmed) illumina reads. This was done through the FastQC gui so there is no script for this step.
3. The script 02_bwa_alignment.sh (in code/02_bwa_pacbio_illumina/) was used to align the illumina reads to the pacbio assembly using bwa. The output was obtained in a sam file. To convert the obtained sam file to a bam file the following command was used: 
```bash
samtools view -S -b pacbio_illumina_alignment.sam > pacbio_illumina_alignment.bam
```
4. The script 03_pilon_polishing.sh (in code/03_pilon_polishing) was used to improve the pacbio assembly using the bam file from step 3. This script also sorted and indexed the bam file using samtools, and outputed a fasta file for the assembly.
5. To check the quality of the polished assembly quast was used (see code/04_quast_quality). 
6. To softmask the pilon polished genome RepeatMasker was used as seen in the script "code/05_repeatmasker/05_repeatmasker.sh". The reference genome produced by the authors of paper 5 was also softmasked using the script "code/05_repeatmasker/reference_repeatmasker.sh". These scripts are essentially the same, only differing in the inputs. 
7. As an extra quality check of the polished assembly, mummer was used as seen below. The resulting PNG of the multiplot can be found in "resutls/mummer/", and is also shown a bit further down in this document. Keep in mind that the script in code/06_mummer does not work, and the code below was run directly on the command line as follows:
```bash
module load bioinfo-tools
module load MUMmer/4.0.0rc1
nucmer /home/allu5328/Documents/genome_analysis/project/Data/Reference_sequences/reference_sequence_scaffold_11.fasta \ 
/home/allu5328/Documents/genome_analysis/project/Data/04_pilon_polishing/pilon.fasta > nucmer_out.txt
delta-filter -q out.delta > out.delta.filter
mummerplot -p multiplot_filtered -l --png out.delta.filter
mummerplot -p filtered --png out.delta.filter
```
8. Trimmomatic was used to trimm the two untrimmed provided RNA sequence files, as seen in the script at code/07_trimmomatic. Quality control before and after trimming was done with FastQC.
9. Star was used to map all trimmed RNA seq files to the pilon polished, softmasked genome assembly to create a bam file using the script "code/08_star/03_star.sh". To map the trimmed RNA sequences to the softmasked reference genome the script "code/08_star/04_star.sh" was used.
10. BRAKER was used to make a structural annotation of the genome assembly using the bam files produced by star as a hint. I could not get this to work with my assembly, so this was only made with the reference assembly using the script "code/09_braker/reference_braker.sh". 
11. To make the gtf file from braker into a protein sequence fasta file this command was used:
```bash
/sw/bioinfo/augustus/3.4.0/snowy/scripts/gtf2aa.pl $genome $gtf prot.fa
```
where $genome is the path to the softmasked reference genome and $gtf the path to the gtf file produced by braker.

12. The file prot.fa was submitted to eggnogmapper using the web interface. All options were kept at their default values.

13. STAR was again used to align the trimmed RNA transcripts to the reference genome, but only from one sample at a time. This time the gtf file produced by braker was used when creating the genome index, as seen in the script "starDE.sh" located at "code/10_star_DE/". 

14. HTSEQ-count was used to count every read mapping to a certain gene using the scripts "htseq_aril.sh", "htseq_aril_097.sh", and "htseq_root.sh", located at "code/11htseq/". Each script made the counting with one sample.

15. DESeq2 was used to make the differential expression analysis using the script "DE_Analysis.R" located at "code/12_DESeq/".

## Analyses and results
In this section a discussion about the different analyses and the subsequent results are presented.

### Quality check of the provided Illumina DNA reads using FastQC
The quality of the provided and trimmed Illumina DNA reads was assessed using FastQC. The quality looked good, the phred score was high for all base positions (which can be seen in the plot below) and everything else looked alright. 
![image](https://github.com/albinlundin/DurianGenomeAnalysis/blob/main/results/FastQC_DNA_Illumina/Illumina_DNA_Phred.png "Phred score")

### Genome assembly

#### Canu
To make the assembly using Canu, the script "01_pacbio_assembly.sh" at "code/01_canu_assembly/" was used. Apart from doing the actual assembly, Canu also performs correction of the bases as well as trimming of low quality regions. In this script the genomeSize parameter was set to 24 million since that is roughly the length for scaffold 11 in the genome assembly produced by the authors of paper 5. The output report from canu gives some statistics about the assembly:
* 87% of the PacBio reads has an overlap, which is a good thing since that means that most of the reads has an overlap.
* NG50 for the assembly equals 1,121,946 bases, meaning that reads of that length or longer makes up 50% of the genome.
* LG50 for the assembly equals to 7 contigs, meaning that 7 contigs makes up the 50% of the genome.
* Total length of the assembly equals 31.5 million base pairs. 
* Number of contigs in the assembly is 745.

My assembly is quite a bit longer compared to the one produced by the authors of paper 5, being approximately 30% longer. My assembly also consists of many contigs which does not look so good since a lower number of contigs is preferrable. However, I am quite satisfied with the LG50 and NG50 values since the LG50 value is low meaning that I do have some long contigs. Notice that these two values are in relation to the genomeSize parameter that was specified in the script to 24 million bases, and not to the total length of the assembly. 

#### BWA
To align the paired end Illumina DNA reads to the canu assembled genome BWA was used according to the script "02_bwa_alignment.sh" located at "code/02_bwa_pacbio_illumina/". Here I used the commands bwa aln and bwa sampe, which generates alignments given paired-end data. However, I now realize that bwa mem would have been a better choice for the alignment due to it being more accurate, according to the BWA manual. I am not sure to what extent this might have affected my assembly.

#### Pilon
To improve the canu assembly, pilon was used according to the script "03_pilon_polishing.sh" located at "code/03_pilon_polishing/". There are not many choices to be made here, or any outputed statistics so there is not much to discuss about this particular step. 

#### RepeatMasker
To mask the assembly for repetetive sequences, repeatmasker was used according to the script "05_repeatmasker.sh" at "code/05_repeatmasker/". The used option '-xsmall' softmasks the genome. Some output metrics include that 2.68% of the assembly consisted of simple repeats, 1.1% of the genome had low complexity, and the GC level was measured to 30.6%. Repeatmasker was also used to softmask the reference sequence produced by the authors of paper 5 according to the script "reference_repeatmasker.sh", which ended up being the softmasked sequence used for the subsequent annotations and differential expression analysis.



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

A duplication ratio larger than 1 is quite expected considering that the total length of my assembly is 31.5 million bases, while the reference assembly roughly is 24 million bases. This can happen if the assembly has multiple contigs covering the same part of the reference, which happens if the assembly overestimates how many times a certain repeat sequence appears in a repeat region. Of course, it would have been better if the assembly length was closer to the actual length.

The largest alignment being 1,421,498 bases long I consider as an ok value. The highest score this assembly could acheive on this metric is 2,660,159 bases which is the same as the largest contig length. The fact that these two metrics are not the same indicates that there is at least one missassembly event in the largest contig in the assembly, which is also something that could be improved. 

Overall, there were 258 missassemblies detected by QUAST which I think is quite high and definitely something that could be improved. The total number of contigs having missassemblies being 126 is something that indicates that the missassemblies is spread accross a quite large fraction of the contigs and not just confined to a few of the contigs, which would have been preferred. 

I consider a NG50 value of 1,122,122 and a LG50 value of 7 to be quite good, indicating that most of my assembly is consisting of long contigs and that only 7 contigs in the assembly is needed for covering 50% of the reference. If looking at a slight larger part of the reference genome the NG75 value is 305,427 bases and the LG75 value is 19, which I also consider to be good values. However, something yet again indicating missassemblies in these long contigs are the NGA50 and LGA50 values (being 315,796 and 21 respectively), taking a significant drop compared to the NG50 and LG50 values. LGA50 and NGA50 only considers correct assemblies, breaking up contigs with missassemblies, which in this case means that my 7 longest contigs contains quite a few missassemblies.

There were also quite a few fully unaligned contigs, being 189 in total, taking up a significant fraction of the total number of contigs in the assembly. However, since their combined length is 2,067,295 it means that the average length of these contigs roughly is 11,000 bases which is not very long compared to some of the other contigs produced, and therefore these contigs maybe were not as good anyway. 

To conclude the QUAST quality assessment, I think that the metrics look quite good apart from the apparent missassemblies. 

#### MUMmerplot
As an extra quality check of the genome assembly, mummerplot was used (or more specific nucmer and mummerplot) as described in the pipline section of this readme document (seen above). Note that the script at "code/mummer/" does not work. The following image (which can also be found at "results/mummer/") shows the multiplot produced by mummer:
![image](https://github.com/albinlundin/DurianGenomeAnalysis/blob/main/results/mummer/multiplot_filtered.png "Mummer multiplot")

In this plot it is quite obvious that the assembly is quite a bit longer than reference sequence, but the continuous, red, diagonal line indicates that the content of the assembly is coherent with the reference, even if it consists of quite a few more contigs.

### RNA reads quality control an Reads preprocessing
#### RNA seq quality check and preprocessing using FastQC and Trimmomatic
The quality of the two untrimmed RNA seq files were checked using FastQC by typing FastQC on the commandline and working through the FastQC gui. By looking at the per base sequence quality it was determined that the quality of the reads were significantly dropping at the end of the sequences, as seen in the following plot:
![image](https://github.com/albinlundin/DurianGenomeAnalysis/blob/main/results/FastQC_rna/before_preprocessing/RNA_phred_before_trimm.png "Phred scores before trimming")

To fix this, Trimmomatic was used as seen in the script "07_trimmomatic.sh" located at "code/07_trimmomatic/". Here, the trimming step "ILLUMINACLIP" was used to remove illumina specific sequences from the reads, using the provided fasta file "TruSeq3-PE.fa" for adapter sequences. The fasta file "TruSeq3-PE.fa" was used since the authors of paper 5 used a HiSeq machine, which according to the trimmomatic manual means that one should use TruSeq3 fasta files. In addition to the "ILLUMINACLIP", the trimming step "TRAILING" was used. This trimming step removes bases at the end of the sequences below a certain quality, which in this case was set to 20 (which is the standard acceptable minimum quality according to the lectures of this course). 

To check the quality of the trimmed reads FastQC was used once again. Shown below is the phred per base sequence quality plot after trimming:
![image](https://github.com/albinlundin/DurianGenomeAnalysis/blob/main/results/FastQC_rna/after_preprocessing/RNA_phred_after_trimm.png "Phred scores after trimming")

The phred score definetely improved after trimming which is positive. Also, worth noting is that FastQC complains about sequence duplication levels and overrepresented sequences after trimming, but I think that is fine since this is regarding RNA sequences meaning that there could be naturally occuring uneven coverage of the different RNA transcripts. 

### Mapping, structural-, and functional annotation 
#### Star mapping
In order to do a structural annotation using braker a bam file of aligned RNA sequences to a reference genome is needed. For this purpose, STAR is used. At "code/08_star/" there are four shell scripts of which all are working. However, there was an unresolved issue when using an alignment with my assembly when using braker resulting in a few scripts trying out a few different things. Eventually, the alignment was made with the reference sequence according to the script "04_star.sh", which ended up working with braker. Probably my assembly is a bit too fragmented for it to work properly with braker, but I am not completely sure about this. The script "04_star.sh" ouputs one bam file, covering all paired end RNA sequence fastq files. 

#### Structural annotation
To make the structural annotaion braker was used according to the script "reference_braker.sh" located at "code/09_braker/". Running braker was quite problematic when using a bam file with my assembly which for some reason would not work, even though the braker code for this bam file (script "08_braker.sh") essentially is the same as the one that ended up working for the reference sequence. As previously stated, this might have happened because of my alignment being too fragmented.

#### Functional annotation
In order to make a functional annotation, the gtf file produced by braker was made into a protein sequence fasta using the AUGUSTUS script "gtf2aa.pl" (which can be seen in the pipeline section of this document). The resulting protein fasta sequences were then uploaded to the online version of eggnog-mapper, which was run with the default settings. The annotations was mostly inferred from the taxonomic level Streptophyta, which Durian belongs to. 

### Differentaial expression analysis
#### RNA reads mapping using star
In order to do the differential expression analysis, star was once again used to map the RNA transcripts to the reference assembly (specify which transcripts) with the script "starDE.sh" located at "code/10_star_DE/". This time, the gtf file produced by braker was supplied when creating the genome index. The option sjdbOverhang was set to 100 since the optimal value is calculated as "Max(readlength)-1", and the longest RNA read being 101 basepairs long. This time 1 bam file was produced for each sample used.

#### Read counting using HTSeq
To count the reads mapping to each gene, HTSeq-count was used according to the scripts "htseq_aril.sh", "htseq_aril_097.sh" and "htseq_root.sh" located at "code/11htseq/". The original gtf-file produced by braker did not work for HTSeq-count since some rows did not have the "transcript_id" or "gene_id" attributes in the last column. In order to make it work, all lines with the attribut "transcript_id" were extracted using grep and put into a new file like this: 
```bash
cat augustus.hints.gtf | grep 'transcript_id' > augustus.hints_removed.gtf
```


#### Comparison of read counts using DESeq2
To make the expression analysis DESeq2 was used, according to the script "DE_analysis.R" located at "code/12_DESeq", to compare the expression levels between fruit aril and root for the Musang King cultivar. Worth pointing out is that no replicates were used for the expression levels in roots, since only one RNA sequence file was provided. For the fruit aril, two replicates were used for the expression analysis. 

Using DESeq, a log2 fold change plot, and a heatmap showing the genes with the highest variances of normalized readcounts between samples, was created as seen below. 

Log fold change plot             |  Heatmap showing the genes having the highest variance between samples, normalized to library size
:-------------------------:|:-------------------------:
![image](https://github.com/albinlundin/DurianGenomeAnalysis/blob/main/results/DE_analysis/log2foldchange_noiseRemoved.png "log2 fold change plot")  |  ![image](https://github.com/albinlundin/DurianGenomeAnalysis/blob/main/results/DE_analysis/heatmap_mostVaried.png "Heatmap showing the genes with the highest variance between samples, normalized to library size")

To remove the noise from genes with low counts in the log fold change plot, the function "lfcshrink" was used before plotting. The log fold change plot shows the distribution of log fold change values for the genes. The heatmap was created by first transforming the count data to the log2 scale using the function "rlog", which also normalizes in regard to library size. Then the 30 genes with the highest variance between samples were extracted, and centered by removing the rowmean from each value in every row. Subsequently, the heatmap displays some of the genes with the highest and lowest log fold changes when comparing root and fruit aril. In the heatmap it can also be seen that there is some variation in expression levels between the two aril samples, most noticeable for genes g609 and g2215. These genes have a much higher expression in one aril compared to the other, which seems a bit strange considering they are from the cultivar and both of them being in the same developmental stage (matured). Anyway, the high expression in one of the arils is enough for making the log fold change of these genes quite high.

The gene g609 has, according to the functional annotation of the Durian genome, the function "V-type proton ATPase subunit". The article "Significance of the V‐type ATPase for the adaptation to stressful growth conditions and its regulation on the molecular and biochemical level" [1] mentions that the V-type ATPase is important for the growth of plants, in which case it makes sense that it is more expressed in fruit arils compared to roots if the arils have a higher growth rate. However, since the expression levels are quite different between arils for this gene, as seen in the heatmap, this is probably not the whole explanation. The authors of the article also bring up that the expression levels for this gene can be altered by stress conditions such as salinity, drought and excess heavy metal in the soil. For instance, an ice plant in saline conditions were found to have a decrease in expression levels of V‐ATPase subunit E in the root, whereas leafs would have an increased expression level of the same protein. Maybe similar stress conditions could explain the differences between the two fruit arils, altough it seems a bit unlikely considering that both durian fruits used in this project were harvested from the same farm.

Another gene that has a higher expression in fruit arils compared to the root, is gene g268 which also can be seen in the heatmap. According to the functional annotation, this gene has the function "Myo-inositol oxygenase". In the paper "myo-Inositol Oxygenase Offers a Possible Entry Point into Plant Ascorbate Biosynthesis" [2] the authour suggest that myo-inositol oxygenase is the initial substrate in the biosynthesis of Ascorbate, also known as vitamin C. Ascorbate have several important functions in plants according to the paper "The Role of Ascorbate in Plant Growth and Development" [3], for instance it is involved in hormone biosynthesis and plant growth. The paper also suggests that Ascorbate is an inductor of seed germination, in which case it makes sense for this gene to have a higher expression in fruit arils compared to roots.

One gene having higher expression in roots compared to fruit arils is g1252 (which is also present in the heatmap). This gene has the function "Dehydration-responsive element-binding protein" meaning it is a stress responsive gene, which according to *Pradeep K. et al* [4] is activated by abiotic stress responses such as high and low temperatures, drought, and high salinity. Since roots are responsible for water and nutrient takeup, it seems reasonable that this gene has a higher expression in roots compared to fruit arils if it is growing in stressful conditions. Gene g535 have the same function as g1252, and it also have higher expression in roots compared to arils.

Another gene that has higher expression in roots compared to fruit arils is g2663. The function of this gene is to remove the phosphate from trehalos 6-phosphate to produce free trehalose. According to *Lunn J.E. et al* [5] trehalose is a potential signal metabolite for interactions between plants and pathogenic or symbiotic microorganisms and insects. Trehalose is also involved in responses to cold and salinity, as well as in regulation of water-use efficiency. With these functions in mind, it seems reasonable that the roots have a higher expression of this protein compared to the arils, especially if the durians are growing in stressful conditions. 

As a side note, none of the functions discussed above were mentioned in paper 5. The functions examined in the paper were related to the distinct smell of Durian fruits. In paper 5, the sulfur related gene MGL and the ethylene related gene ACS were upregulated. In this project, the MGL function was found for one gene which did not display any significant upregulation, while the ACS function was found for several genes of which none showed any significant up- or down regulation. In paper 5, the processes found upregulated in non-fruit organs were related to photosynthesis and nitrogen metabolism. For this project, no genes with related functions were found, but it was not expected to find an upregulated gene related to photosynthesis since the only non-fruit organ examined in this project was a root. The differenece in findings between paper 5 and this project could be explained by only a small part of the genome being examined in this project, and thus not having all smell related genes present. Also, not all genes with significant upregulation were examined since there were quite a few, meaning that some might have been missed. 


##### References
[1] K.J. Dietz, N. Tavakoli, C. Kluge, T. Mimura, S.S. Sharma, G.C. Harris, A.N. Chardonnens, D. Golldack. Significance of the V‐type ATPase for the adaptation to stressful growth conditions and its regulation on the molecular and biochemical level, Journal of Experimental Botany, Volume 52, Issue 363, 1 October 2001, Pages 1969–1980, https://doi.org/10.1093/jexbot/52.363.1969

[2] Argelia Lorence, Boris I. Chevone, Pedro Mendes, Craig L. Nessler, myo-Inositol Oxygenase Offers a Possible Entry Point into Plant Ascorbate Biosynthesis, Plant Physiology, Volume 134, Issue 3, March 2004, Pages 1200–1205, https://doi.org/10.1104/pp.103.033936

[3] Ortiz-Espín A., Sánchez-Guerrero A., Sevilla F., Jiménez A. (2017) The Role of Ascorbate in Plant Growth and Development. In: Hossain M., Munné-Bosch S., Burritt D., Diaz-Vivancos P., Fujita M., Lorence A. (eds) Ascorbic Acid in Plant Growth, Development and Stress Tolerance. Springer, Cham. https://doi-org.ezproxy.its.uu.se/10.1007/978-3-319-74057-7_2

[4] Pradeep K. Agarwal, Kapil Gupta, Sergiy Lopato, Parinita Agarwal, Dehydration responsive element binding transcription factors and their applications for the engineering of stress tolerance, Journal of Experimental Botany, Volume 68, Issue 9, 1 April 2017, Pages 2135–2148, https://doi.org/10.1093/jxb/erx118

[5] Lunn, J.E., Delorge, I., Figueroa, C.M., Van Dijck, P. and Stitt, M. (2014), Trehalose metabolism in plants. Plant Journal, 79: 544-567. https://doi.org/10.1111/tpj.12509

### Questions from the student manual
This section contains answers to (some) of the questions from the student manual.

#### Questions from the Student manual regarding the assembly process
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

#### Questions from the student manual regarding quality assessment
1. What do measures like N50, N90, etc. mean? How can they help you evaluate the quality of your assembly? Which measure is the best to summarize the quality of the assembly (N50, number of ORFs, completeness, total size, longest contig ...)

* N50 - Contigs of this length or longer are needed to cover 50% of the assembly length
* NG50 - Contigs of this length or longer are needed to cover 50% of the reference length
* L50 - This many contigs are needed to cover 50% of the assembly length
* LG50 - This many contigs are needed to cover 50% of the reference length
* NGA50 - Same as NG50, with the difference that any contigs containing missassemblies in regard to the reference will be broken into smaller contigs
* LGA50 - Same as LG50, with the difference that any contigs containing missassemblies in regard to the reference will be broken into smaller contigs

For any of the metrics listed above the '50' can be changed to any number between 0 and 100, thus reflecting any other percentage of the assembly or reference length. For example, N75 means: Contigs of this length or longer are needed to cover 75% of the assembly length. 

2. How does your assembly compare with the reference assembly? What can have caused the differences?

The largest difference between my assembly and the reference is the length. As discussed above, this could have happened if the assembler overestimates how many times a repeat sequence is present in repeat region. 

3. Why do you think your assembly is better/worse than the public one?

I think my assembly is worse than the public available one, becuase of the vast number of contigs in the assembly as well as the many missassemblies. 

#### Questions from the student manual regarding Reads quality control
- What is the structure of a FASTQ file?
- How is the quality of the data stored in the FASTQ files? How are paired reads identified?
- How is the quality of your data?
- What can generate the issues you observe in your data? Can these cause any problems during subsequent analyses?

#### Questions from the student manual regarding reads preprocessing
- How many reads have been discarded after trimming?
- How can this affect your future analyses and results?
- How is the quality of your data after trimming?
- What do the LEADING, TRAILING and SLIDINGWINDOW options do?

##### Questions from the student manual regarding mapping
- What percentage of your reads map back to your contigs? Why do you think that is?
- What potential issues can cause mRNA reads not to map properly to genes in the chromosome? Do you expect this to differ between prokaryotic and eukaryotic projects?
- What percentage of reads map to genes?
- How many reads do not map to genes? What does that mean? How does that relate to the type of sequencing data you are mapping?
- What do you interpret from your read coverage differences across the genome?
- Do you see big differences between replicates? (maybe does not apply to this project???)

##### Questions from the student manual regarding annotation
- What types of features are detected by the software? Which ones are more reliable a priori?
- How many features of each kind are detected in your contigs? Do you detect the same number of features as the authors? How do they differ?
- Why is it more difficult to do the functional annotation in eukaryotic genomes?
- How many genes are annotated as ‘hypothetical protein’? Why is that so? How would you tackle that problem?
- How can you evaluate the quality of the obtained functional annotation?
- How comparable are the results obtained from two different structural annotation softwares?
