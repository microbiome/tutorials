if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
library(BiocManager)


.cran_packages <- c("ggplot2", "gridExtra",'ape', 'dplyr','ggpubr', 'knitr','Cairo','devtools','data.table', 
                    'splitstackshape', 'rmarkdown', 'tidyverse', 'readxl', 'vegan','knitcitations', 'reshape', 'reshape2', 
                    'magrittr', 'vegan', 'glue','stringr','devtools','captioner', 'rstan','rstanarm',
                    'hrbrthemes', 'gcookbook','GGally', 'rvg','ggiraph','network', 'gplots',
                    'intergraph', 'rmdformats', 'FD', 'hrbrthemes', 'GGally', 'lattice', 'venn', 'PMCMRplus')

.bioc_packages <- c("dada2", "phyloseq",'SummarizedExperiment','Biobase', 
                   "DECIPHER",'IRanges','BiocGenerics', "phangorn",
                    'BiocStyle', "microbiome", "DESeq2", 'DirichletMultinomial')

# package.version("microbiome")
#[1] "1.5.31"
.inst <- .cran_packages %in% installed.packages()
if(any(!.inst)) {
  install.packages(.cran_packages[!.inst])
}
sapply(.cran_packages, require, character.only = TRUE)


library('devtools')
install_github('zdk123/SpiecEasi')
install_github('briatte/ggnet')

.inst <- .bioc_packages %in% installed.packages()
if(any(!.inst)) {
  #source("http://bioconductor.org/biocLite.R")
  
  BiocManager::install(.bioc_packages[!.inst], ask = F)
}
install_github('antagomir/netresponse')
install_github('microsud/microbiomeutilities')
###
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install(c(.bioc_packages,"SummarizedExperiment", 'DelayedArray'))
# Load packages into session, and print package version
sapply(c(.cran_packages, .bioc_packages), require, character.only = TRUE)

