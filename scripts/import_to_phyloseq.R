library(phyloseq)
library(tidyverse)

# Read the combined results CSV
abund <- read.csv("output/combined_results.csv", row.names = 1)

# Convert to matrix and create OTU table
otu_mat <- as.matrix(abund)
OTU <- otu_table(otu_mat, taxa_are_rows = TRUE)

# Create a basic phyloseq object
ps <- phyloseq(OTU)
ps

# Optional: add sample metadata if you have a samples.tsv
# meta <- read.delim("test/samples.tsv", row.names = 1)
# sampledata <- sample_data(meta)
# ps <- phyloseq(OTU, sampledata)

# Optional: add taxonomy if you have a mapping file
# tax <- read.csv("subspecies_taxonomy.csv", row.names = 1)
# TAX <- tax_table(as.matrix(tax))
# ps <- phyloseq(OTU, TAX, sampledata)

# Normalize to relative abundances
ps_ra <- transform_sample_counts(ps, function(x) x / sum(x))

# Plot
# plot_bar(ps_ra, fill = "OTU")

# Diversity
# plot_richness(ps, measures = c("Shannon", "Simpson"))
