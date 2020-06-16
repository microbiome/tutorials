library(dplyr) 
library(microbiome)
data("atlas1006") # example data from microbiome pkg
x <-atlas1006

asv_tab <- as.data.frame(abundances(x)) # get asvs/otus
asv_tab$asv_id <- rownames(asv_tab) # add a new column for ids
tax_tab <- as.data.frame(tax_table(x)) # get taxonomy note: can be slow
tax_tab$asv_id <- rownames(tax_tab) # add a new column for ids
asv_tax_tab <- tax_tab %>% 
  right_join(asv_tab, by="asv_id") # join to get taxonomy and asv table

# save the data to user specified path 
write.table(asv_tax_tab, "asv_tax_tab.txt", sep="\t", row.names = F)
