# Read input from HTSeq
directory <- "C:\\Users\\Albin\\Documents\\Kurser\\Genome analysis\\DE\\"
sampleFiles <- grep("_",list.files(directory),value=TRUE)
sampleCondition <- c('aril', 'root')
sampleTable <- data.frame(sampleName = sampleFiles, fileName = sampleFiles, 
                          condition = sampleCondition)
sampleTable$condition <- factor(sampleTable$condition)
library("DESeq2")
ddsHTSeq <- DESeqDataSetFromHTSeqCount(sampleTable = sampleTable, 
                                       directory = directory, 
                                       design= ~ 1)

# Set root as the reference level
ddsHTSeq$condition <- relevel(ddsHTSeq$condition, ref = "root")

# DESeq Results
ddsHTSeq <- DESeq(ddsHTSeq)
res <- results(ddsHTSeq)

# Log 2 change plot
plotMA(res, ylim=c(-2,2))
plotMA(res, ylim=c(-2,20))

# Find the most up and down regulated genes
# Order by log2FoldChange
resLog <- res[order(res$log2FoldChange),]
# Omit NA from the log2FoldChange column
na <- complete.cases(resLog[,"log2FoldChange"])
resLog <- resLog[na,]
resLog

# Create heatmap
library(pheatmap)
select <- order(rowMeans(counts(ddsHTSeq,normalized=TRUE)), decreasing=TRUE)[1:20]
ntd <- normTransform(ddsHTSeq)
pheatmap(assay(ntd)[select,], cluster_rows=FALSE, show_rownames=FALSE, cluster_cols=FALSE)
