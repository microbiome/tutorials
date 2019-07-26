# source('init.R')
library(microbiome)
library(phyloseq)
library(netresponse)
library(MASS)
library(dplyr)
library(tidyr)
library(ggplot2)
library(devtools)
library(ggplot2)
library(microbiome)
library(rmarkdown)
library(knitr)
library(knitcitations)

# ---------------------------------------------

# List the Rmd files to render
fs <- sample(list.files(pattern = ".Rmd$")) # Random order

# List rendering options
knitr::opts_chunk$set(fig.path = "figure/", dev="CairoPNG")
times <- c()

# Render all files
for (myfile in fs) {

    times[[myfile]] <- system.time(rmarkdown::render(myfile))

}

rmarkdown::render("info.Rmd")

# git add + commit + push
system("git add figure/*")
system("git add *.Rmd")
system("git add *.html")
system("git commit -a -m'homepage update'")
system("git push origin master")

