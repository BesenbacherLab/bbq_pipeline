sink(snakemake@log[[1]], append=TRUE)

library(tidyverse)
library(data.table)

filename = snakemake@input[[1]]
data = fread(filename, sep = "\t", header = FALSE, stringsAsFactors = FALSE)

ostrand = list('A'='T', 'C'='G', 'G'='C', 'T'='A')
data <- data %>% group_by(V4, V5) %>% 
    mutate(ref_comb = ifelse(V4 %in% c("G", "T"), ostrand[V4][[1]], V4), 
           alt_comb = ifelse(V4 %in% c("G", "T"), ostrand[V5][[1]], V5), 
           mut_type = paste0(ref_comb, "->", alt_comb))

data_sum_muttype <- data %>%
    group_by(mut_type) %>%
    summarize(n = n())

options(repr.plot.width=8, repr.plot.height=6)
p <- ggplot(data_sum_muttype) + 
    geom_col(aes(x = mut_type, y = n), fill = "steelblue") + 
    theme_bw() + 
    theme(text = element_text(size = 18)) + 
    xlab("Mutation type") + 
    ylab("Number of variants")

ggsave(filename=snakemake@output[["mut_type_counts"]], plot=p, device='png', dpi=300, width = 17, height = 7)

AF <- as.numeric(str_split_fixed(str_split_fixed(data$V8, ";", 25)[, 1], "=", 2)[, 2])
cov <- as.numeric(str_split_fixed(str_split_fixed(data$V8, ";", 25)[, 2], "=", 2)[, 2])

options(repr.plot.width=6, repr.plot.height=6)
p <- ggplot() + 
    geom_histogram(aes(x = AF), binwidth = 0.005, fill = "grey", color = "darkgrey") + 
    theme_bw() + 
    theme(text = element_text(size = 14)) + 
    ylab("Number of variants") +
    xlab("Allele frequency") + 
    xlim(0, 0.5)

ggsave(filename=snakemake@output[["allele_frequency"]], plot=p, device='png', dpi=300, width = 17, height = 7)

options(repr.plot.width=8, repr.plot.height=6)
p <- ggplot() + 
    geom_histogram(aes(x = cov), binwidth = 1, fill = "grey", color = "darkgrey") + 
    theme_bw() + 
    theme(text = element_text(size = 14)) + 
    ylab("Number of variants") +
    xlab("Filtered coverage")

ggsave(filename=snakemake@output[["coverage"]], plot=p, device='png', dpi=300, width = 17, height = 7)

sink()