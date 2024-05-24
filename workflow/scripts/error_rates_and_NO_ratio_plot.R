sink(snakemake@log[[1]], append=TRUE)

library(tidyverse)
library(ggrepel)

no_ratio_file <- snakemake@input[[1]]
no_ratio <- read.table(no_ratio_file, sep = " ", header = TRUE, stringsAsFactors = FALSE)
no_ratio <- no_ratio %>% mutate(phred = -10*log10(kmerpapa_rate))

## kmerPaPa plot
min_pat = no_ratio %>% group_by(BQ, mutationtype) %>% filter(phred == min(phred)) 
max_pat = no_ratio %>% group_by(BQ, mutationtype) %>% filter(phred == max(phred))
mean_error_rate = no_ratio %>% group_by(mutationtype, BQ) %>% summarize(mean = mean(phred))

options(repr.plot.width=17, repr.plot.height=7)
p <- ggplot(no_ratio) + 
    geom_point(aes(x = phred, y = BQ), color = "steelblue", size = 2) + 
    geom_segment(data = mean_error_rate, aes(x = mean, xend = mean, y = BQ-3, yend = BQ+3), linewidth = 0.5, linetype = 1, color = "black") + 
    geom_text_repel(data = min_pat, aes(x = phred, y = BQ, label=pattern), size = 4, nudge_x = -7, nudge_y = -3) +
    geom_text_repel(data = max_pat, aes(x = phred, y = BQ, label=pattern), size = 4, nudge_x = 7, nudge_y = 3) +
    facet_wrap(~mutationtype, nrow = 2) + 
    theme_bw() + 
    theme(text = element_text(size = 18)) + 
    xlab("Phred scaled predicted error rate") + 
    ylab("Base quality") + 
    scale_y_continuous(breaks = c(11, 25, 37), labels = c("11", "25", "37"), limits = c(5, 45))

ggsave(filename=snakemake@output[["error_rates"]], plot=p, device='png', dpi=300, width = 17, height = 7)

## NO-ratio plot
#options(repr.plot.width=6, repr.plot.height=6)
colors1 <- c("11" = "indianred", "25" = '#74AC64', "37" = 'steelblue')

data_mean <- no_ratio %>% group_by(BQ, mutationtype) %>% summarise(mean_relative_EQ = mean(relative_EQ)) %>% ungroup()

p <- ggplot(no_ratio, aes(x = factor(mutationtype), y = relative_EQ)) +
    geom_point(aes(color = as.character(BQ)),
                position = position_jitterdodge(jitter.width = 0.17, seed = 1), 
                alpha = 0.6) + 
    geom_boxplot(data = data_mean, aes(x = factor(mutationtype), y = mean_relative_EQ, middle = mean(mean_relative_EQ), fill = as.character(BQ)),
                 outlier.shape = NA,
                 alpha = 0, 
                 show.legend = FALSE) + 
    scale_color_manual(name='Base Quality',
                       values= colors1, limits = c("11", "25", "37")) + 
    theme_bw() + 
    theme(text = element_text(size = 18), 
        legend.position = "bottom") + 
    xlab("Mutation type") + 
    ylab("NO-ratio")

ggsave(filename=snakemake@output[["NO_ratio"]], plot=p, device='png', dpi=300, width = 17, height = 7)

sink()