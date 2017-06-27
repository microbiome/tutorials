<!--
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteIndexEntry{microbiome tutorial - limma}
  %\usepackage[utf8]{inputenc}
  %\VignetteEncoding{UTF-8}  
-->
Two-group comparison at community level with limma
==================================================

Load example data:

    # Load libraries
    library(microbiome)
    library(ggplot2)
    library(dplyr)

    # Probiotics intervention example data 
    data(peerj32) # Source: https://peerj.com/articles/32/
    pseq <- peerj32$phyloseq # Rename the example data

    # Get OTU abundances and sample metadata
    otu <- abundances(microbiome::transform(pseq, "log10"))
    meta <- meta(pseq)

### Linear models with limma

Identify most significantly different taxa between males and females
using the limma method. See [limma
homepage](http://bioinf.wehi.edu.au/limma/) and [limma User's
guide](http://www.lcg.unam.mx/~lcollado/R/resources/limma-usersguide.pdf)
for details. For discussion on why limma is preferred over t-test, see
[this
article](http://www.plosone.org/article/info:doi/10.1371/journal.pone.0012336).

    # Compare the two groups with limma
    library(limma)

    # Prepare the design matrix which states the groups for each sample
    # in the otu
    design <- cbind(intercept = 1, Grp2vs1 = meta[["gender"]])
    rownames(design) <- rownames(meta)
    design <- design[colnames(otu), ]

    # NOTE: results and p-values are given for all groupings in the design matrix
    # Now focus on the second grouping ie. pairwise comparison
    coef.index <- 2
         
    # Fit the limma model
    fit <- lmFit(otu, design)
    fit <- eBayes(fit)

    # Limma P-values
    pvalues.limma = fit$p.value[, 2]

    # Limma effect sizes
    efs.limma <-  fit$coefficients[, "Grp2vs1"]

    # Summarise
    library(knitr)
    kable(topTable(fit, coef = coef.index, p.value=0.1), digits = 2)

<table>
<thead>
<tr class="header">
<th></th>
<th align="right">logFC</th>
<th align="right">AveExpr</th>
<th align="right">t</th>
<th align="right">P.Value</th>
<th align="right">adj.P.Val</th>
<th align="right">B</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>Uncultured Clostridiales II</td>
<td align="right">-0.41</td>
<td align="right">1.37</td>
<td align="right">-3.72</td>
<td align="right">0</td>
<td align="right">0.06</td>
<td align="right">-0.24</td>
</tr>
<tr class="even">
<td>Eubacterium siraeum et rel.</td>
<td align="right">-0.34</td>
<td align="right">1.67</td>
<td align="right">-3.52</td>
<td align="right">0</td>
<td align="right">0.06</td>
<td align="right">-0.77</td>
</tr>
<tr class="odd">
<td>Clostridium nexile et rel.</td>
<td align="right">0.18</td>
<td align="right">2.84</td>
<td align="right">3.41</td>
<td align="right">0</td>
<td align="right">0.06</td>
<td align="right">-1.04</td>
</tr>
<tr class="even">
<td>Sutterella wadsworthia et rel.</td>
<td align="right">-0.33</td>
<td align="right">1.50</td>
<td align="right">-3.13</td>
<td align="right">0</td>
<td align="right">0.10</td>
<td align="right">-1.74</td>
</tr>
</tbody>
</table>

Quantile-Quantile plot and volcano plot for limma

    # QQ
    qqt(fit$t[, coef.index], df = fit$df.residual + fit$df.prior); abline(0,1)

    # Volcano
    volcanoplot(fit, coef = coef.index, highlight = coef.index)
