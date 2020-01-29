library(MASS)
library(dplyr)

# Load functions
source("ancom.R")

# Load example data
library(microbiome)
data(dietswap)
pseq <- dietswap

# Use CLR abundances
pseq <- transform(pseq, "compositional")

# Initialize results
groups <- c("sex", "nationality")
pvals.ancom <- matrix(NA, nrow = ntaxa(pseq),
                            ncol = length(groups))
rownames(pvals.ancom) <- taxa(pseq)
colnames(pvals.ancom) <- groups


for (gr in groups) {

    # Run ANCOM for comparisons within this group
    print(gr)
  
    ps <- pseq
    sample_data(ps)$group <- unlist(meta(ps)[, gr])
    ps <- subset_samples(ps, !is.na(group))  
    
    v <- ancom(ps, "group")

    pvals.ancom[names(v), gr] <- v
    
  }

print("ANCOM for loop ok")

# Note: multiple testing is done per group by ANCOM
# We do not apply further correction
pvals.ancom <- pvals.ancom[which(rowMeans(pvals.ancom < 0.05) > 0),]

# Add fold change information
library(reshape)
dfm <- melt(pvals.ancom)
names(dfm) <- c("OTU", "Grouping", "pval.ancom")
dfm$relab.cond <- rep(NA, nrow(dfm))
dfm$relab.control <- rep(NA, nrow(dfm))
dfm$log10FC <- rep(NA, nrow(dfm))

# Provide a table with relative abundances and log10 fold changes
# for each group
# If log10FC is infinite it means that all controls for this tax are 0
check <- c()

pseq.clr <- transform(pseq, "clr")  
for (i in 1:nrow(dfm)) {

    tax <- as.character(dfm[i, 1])
    loc <- as.character(dfm[i, 2])    
    x <- get_sample(pseq, tax)
    x.clr <- get_sample(pseq.clr, tax)    

    gr <- meta(pseq)[, loc]
    N <- as.numeric(gr)
    N <- N - min(N, na.rm = TRUE)
    
    cond <- mean(x[which(N == 1)], na.rm = TRUE)
    control <- mean(x[which(N == 0)], na.rm = TRUE)

    cond.clr <- mean(x.clr[which(N == 1)], na.rm = TRUE)
    control.clr <- mean(x.clr[which(N == 0)], na.rm = TRUE)
    
    dfm[i,"relab.cond"]    <- 100 * cond
    dfm[i,"relab.control"] <- 100 * control

    # Check fold-changes with CLR transformed data
    dfm[i,"log10FC"] <- log10(exp(cond.clr - control.clr))

    # Verify that comp and clr abundance FC are consistent
    check <- rbind(check,
                c(
		    cond.clr = cond.clr,
		    control.clr = control.clr,
		    cond = cond,
		    control = control,		    
		    clr.fc = log10(exp(cond.clr - control.clr)),
    	           comp.fc = log10(cond/control)
		   
                   ))
    
}
  

res.ancom <- dfm %>% arrange(pval.ancom) %>% filter(log10FC < 1)



print("ANCOM ok")

