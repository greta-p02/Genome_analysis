library("DESeq2")
library("apeglm")
library("pheatmap")
library("ggplot2")
library("reshape2")

#Putting in the counts file
counts <- read.delim("counts_output.txt", header = FALSE, row.names = 1)

#Adding sample names
colnames(counts) <- c(
  "BH_ERR1797972", "BH_ERR1797973", "BH_ERR1797974",
  "serum_ERR1797969", "serum_ERR1797970", "serum_ERR1797971"
)

#Removing __no_feature, __ambiguous, __too_low_aQual, __not_aligned, __alignment_not_unique rows
counts <- counts[!grepl("^__", rownames(counts)), ]

#Sample names and sample conditions dataframe
sample_info <- data.frame(
  sample = colnames(counts),
  condition = c("BH","BH","BH","serum","serum","serum")
)

rownames(sample_info) <- sample_info$sample


#Making the DESeqDataSet
ddsmatrix <- DESeqDataSetFromMatrix(
  countData = counts,
  colData = sample_info,
  design = ~ condition
)

#Pre-filtering, removing low count genes
ddsmatrix <- ddsmatrix[rowSums(counts(ddsmatrix)) >= 10, ]

#Specifying the control condition
ddsmatrix$condition <- relevel(ddsmatrix$condition, ref = "BH")

#Counts per gene distribution

gene_counts <- rowSums(counts)
rownames(sample_info) <- sample_info$sample

hist(gene_counts,
     breaks = 100,
     main = "Gene count distribution",
     xlab = "Read counts per gene")

hist(log10(gene_counts + 0.1), #+0.1 to avoid getting log(0)
     breaks = 100,
     main = "Distribution of gene expression",
     xlab = "log10(read counts + 0.1)")

sum(gene_counts > 0)
length(gene_counts)

#DE analysis
dds <- DESeq(ddsmatrix)

#DE results
res <- results(dds, contrast = c("condition", "serum", "BH"))
res



#Log fold change shrinkage
resLFC <- lfcShrink(
  dds,
  coef = "condition_serum_vs_BH",
  type = "apeglm",
  lfcThreshold = 1
)

options(scipen = 999)

plotMA(resLFC, ylim = c(-4,4), colNonSig = "grey", colSig = "hotpink")
abline(h = c(-1,1), col = "blueviolet", lwd = 2)



#Volcano plot
res_df <- as.data.frame(res)

res_df$significant <- ifelse(res_df$padj < 0.001 & abs(res_df$log2FoldChange) > 1, "significant", "not significant")

ggplot(res_df, aes(x = log2FoldChange, y = -log10(padj))) +
  geom_point(aes(color = significant), alpha = 0.6) +
  scale_color_manual(values = c("significant" = "hotpink",
                                "not significant" = "grey")) +
  geom_vline(xintercept = c(-1, 1), linetype = "dashed") +
  geom_hline(yintercept = -log10(0.001), linetype = "dashed") +
  labs(x = "log2 Fold Change",
       y = "-log10 adjusted p-value") +
  theme_minimal()



#Adding prokka annotation file

prokka <- read.delim("efaecium_annotate.tsv",
                     header = TRUE,
                     sep = "\t")

#Adding eggnog annotation file (the # that is before header names in the file was manually removed before running this)

eggnog <- read.delim("efaecium_eggnog.emapper.annotations",
                     comment.char = "#",
                     header = TRUE,
                     sep = "\t")

#Making a datafarame out of the deseq results

res_df <- as.data.frame(res)
res_df$gene_id <- rownames(res_df)

#Adding prokka to the deseq res

res_annot <- merge(res_df,
                   prokka,
                   by.x = "gene_id", #gene id in res
                   by.y = "locus_tag", #locus tag in prokka
                   all.x = TRUE) #keep the genes in res even if they dont have annotations

#Adding eggnog to the deseq res

res_annot <- merge(res_annot,
                   eggnog,
                   by.x = "gene_id",
                   by.y = "query",
                   all.x = TRUE)



#Keeping only the most important columns for reporting
colnames(res_annot)
res_clean <- res_annot[, c(
  "gene_id",
  "baseMean",
  "log2FoldChange",
  "padj",
  "gene",
  "product",
  "Preferred_name",
  "Description",
  "COG_category",
  "KEGG_Pathway"
)]

colnames(res_clean)[5] <- "Gene_prokka"
colnames(res_clean)[6] <- "Product_prokka"
colnames(res_clean)[7] <- "Preferred_name_eggnog"
colnames(res_clean)[8] <- "Description_eggnog"



#Significant results based on paper
res_annot_sig <- subset(res_annot,
                 padj < 0.001 &
                 abs(log2FoldChange) > 1)




#Plot single gene counts
plotCounts(
  dds,
  gene = which.min(res_annot$padj),
  intgroup = "condition"
)



#VST transformation
vsd <- vst(dds, blind = FALSE)


#PCA
plotPCA(vsd, intgroup = "condition")

pca <- prcomp(t(assay(vsd)))
summary(pca)



#Heatmap top expressed genes

top20 <- order(rowMeans(assay(vsd)), decreasing = TRUE)[1:20] #across all samples

df <- as.data.frame(colData(vsd)[, "condition", drop = FALSE]) #get the data what is serum what is BH

mat <- assay(vsd)[top20, ] #expression matrix of top 20

match(rownames(mat), res_annot$gene_id)

top20_genes <- res_annot[match(rownames(mat), res_annot$gene_id), ]

labels <- paste0(top20_genes$Preferred_name,
                 " (",
                 top20_genes$gene_id,
                 ")")

pheatmap(mat,
         cluster_rows = FALSE,
         cluster_cols = FALSE,
         show_rownames = TRUE,
         show_colnames = FALSE,
         labels_row = labels,
         annotation_col = df)




#Heatmap all significant genes

genes_sig <- res_annot_sig$gene_id #gene ids of sig genes

mat_sig <- assay(vsd)[genes_sig, ] #matrix with significant genes

pheatmap(mat_sig,
         scale = "row",
         cluster_rows = TRUE,
         cluster_cols = TRUE,
         show_rownames = FALSE,
         show_colnames = FALSE,
         annotation_col = df)




#Heatmap significant most up/down-regulated genes

res_sorted <- res_annot_sig[order(res_annot_sig$log2FoldChange, decreasing = TRUE), ] #order by log2fold

top_up <- head(res_sorted, 10) #10 most upregulated
top_down <- tail(res_sorted, 10) #10 most downregulated

top_genes <- rbind(top_up, top_down) #combine into one dataframe

mat <- assay(vsd)[top_genes$gene_id, ] #matrix

labels <- paste0(top_genes$Preferred_name, " (", top_genes$gene_id, ")")

pheatmap(mat,
         scale = "row",
         cluster_rows = FALSE,
         cluster_cols = FALSE,
         show_rownames = TRUE,
         show_colnames = FALSE,
         labels_row = labels,
         annotation_col = df)


top_20_up <- head(res_sorted, 20)

#COG visualization

sig_cog <- res_annot_sig[nchar(res_annot_sig$COG_category) == 1,] #only keep those who have one letter for cog

up <- sig_cog[sig_cog$log2FoldChange > 0, ] #Positive values
down <- sig_cog[sig_cog$log2FoldChange < 0, ] #Negative values


up_tab <- as.data.frame(table(up$COG_category))
down_tab <- as.data.frame(table(down$COG_category))

colnames(up_tab) <- c("COG", "Up")
colnames(down_tab) <- c("COG", "Down")

cog_compare <- merge(up_tab, down_tab, by = "COG", all = TRUE)

#changing to a long format table for ggplot
plot_df <- melt(cog_compare, id.vars = "COG", variable.name = "Regulation", value.name = "Count")



ggplot(plot_df, aes(x = COG, y = Count, fill = Regulation)) +
  geom_bar(stat = "identity", position = "dodge") + #use values given in the rows, not count them up and put them side by side
  scale_fill_manual(values = c(
    "Up" = "hotpink",
    "Down" = "blueviolet"
  )) +
  xlab("COG category") +
  ylab("Number of DE genes") +
  ggtitle("COG categories of upregulated and downregulated genes in serum") +
  theme(axis.text.x = element_text(angle = 0, hjust = 1))

