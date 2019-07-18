if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager", "Biostyle")


.cran_packages <- c("ggplot2", "gridExtra",'ape', 'dplyr','ggpubr', 'knitr','Cairo','devtools','data.table','splitstackshape', 'rmarkdown',
                    'tidyverse', 'readxl', 'vegan','knitcitations', 'reshape', 'reshape2',
                    'magrittr', 'vegan', 'IRanges','glue','stringr','devtools','captioner', 'rstan','rstanarm',
                    'hrbrthemes', 'gcookbook','GGally', 'rvg','ggiraph','network',
                    'ggnet','intergraph', 'rmdformats', 'FD', 'hrbrthemes')

.bioc_packages <- c("dada2", "phyloseq",'SummarizedExperiment','Biobase', 
                    'BiocInstaller', "DECIPHER",'IRanges','BiocGenerics', "phangorn",
                    'BiocStyle', "microbiome", "DESeq2", 'DirichletMultinomial',
                    'netresponse')

# package.version("microbiome")
#[1] "1.5.31"
.inst <- .cran_packages %in% installed.packages()
if(any(!.inst)) {
  install.packages(.cran_packages[!.inst])
}

library('devtools')
install_github('zdk123/SpiecEasi')
install_github('briatte/ggnet')

.inst <- .bioc_packages %in% installed.packages()
if(any(!.inst)) {
  source("http://bioconductor.org/biocLite.R")
  
  biocLite(.bioc_packages[!.inst], ask = F)
}
install_github('antagomir/netresponse')
install_github('microsud/microbiomeutilities')

# Load packages into session, and print package version
sapply(c(.cran_packages, .bioc_packages, 'SpiecEasi', 'ggnet' ), require, character.only = TRUE)
