library(ggplot2) ## plotting! may not be needed.
library(pheatmap) ## for heatmap generation
library(ggplotify) ## convert pheatmap to ggplot2 compatibility
library(viridis) ## color palette stuff.

args <- commandArgs(trailingOnly=TRUE)

cat(args)

mat_csv <- args[1]
out_fig <- args[2]

# read matrix CSV file, as output by sourmash compare --csv
sourmash_comp_matrix <- read.csv(mat_csv)

# Label the rows
rownames(sourmash_comp_matrix) <- colnames(sourmash_comp_matrix)

# make heatmap!
heatmap_gg <- as.ggplot(pheatmap(sourmash_comp_matrix))
ggsave(out_fig) #, device="png")
