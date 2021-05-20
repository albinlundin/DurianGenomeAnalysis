# DE analysis with replicates
# HTSeq input
directory <- "C:\\Users\\Albin\\Documents\\Kurser\\Genome analysis\\DE_2\\"
sampleFiles <- grep("_",list.files(directory),value=TRUE)
sampleCondition <- sub("(.*_).*","\\1",sampleFiles)
sampleTable <- data.frame(sampleName = sampleFiles,fileName = sampleFiles,condition = sampleCondition)
sampleTable$condition <- factor(sampleTable$condition)

library("DESeq2")
ddsHTSeq <- DESeqDataSetFromHTSeqCount(sampleTable = sampleTable,directory = directory,design= ~ condition)

ddsHTSeq$condition <- factor(ddsHTSeq$condition, levels = c("root_","aril_"))

# results
ddsHTSeq <- DESeq(ddsHTSeq)
res <- results(ddsHTSeq)

# log2foldchange plot
library(apeglm)
resLFC <- lfcShrink(ddsHTSeq, coef="condition_aril__vs_root_", type="apeglm")
plotMA(res, ylim=c(-10,10), main = 'log2foldchange of all genes')
plotMA(resLFC, ylim=c(-10,10), main='log2foldchange with low count noise removed')

# order genes based on log2foldchange, and display them
resLog <- res[order(res$log2FoldChange),]
## omit NA from the log2foldchange column
na <- complete.cases(resLog[,"log2FoldChange"])
resLog <- resLog[na,]
resLog

# heatmap
vsd <- vst(ddsHTSeq, blind=FALSE)
rld <- rlog(ddsHTSeq, blind=FALSE)
library("pheatmap")
select <- order(rowMeans(counts(ddsHTSeq,normalized=TRUE)),decreasing=TRUE)[1:20]
ntd <- normTransform(ddsHTSeq)
pheatmap(assay(ntd)[select,], cluster_rows=TRUE, show_rownames=TRUE,cluster_cols=FALSE)
pheatmap(assay(vsd)[select,], cluster_rows=TRUE, show_rownames=TRUE,cluster_cols=FALSE)
pheatmap(assay(rld)[select,], cluster_rows=TRUE, show_rownames=TRUE,cluster_cols=FALSE)

# pca
plotPCA(vsd, intgroup=c("condition"))


# heatmap showing the genes with most varied genecounts
topVarianceGenes <- head(order(rowVars(assay(rld)), decreasing=T),30)
matrix <- assay(rld)[ topVarianceGenes, ]
matrix <- matrix - rowMeans(matrix)
pheatmap(matrix, cluster_cols=FALSE, main = 'Heatmap of genes with most varied normalized genecounts')


