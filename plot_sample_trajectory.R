# In this we demonstrate how to plot trajactory of a community over time
# We use the human microbiome time series data from Caporaso et al., 2011 Genome Biol.

library(microbiome)
library(jeevanuDB) # external database pkg for microbiome pkg with test data
library(dplyr)
library(ggplot2)
library(viridis)
# Example data
data("moving_pictures")
# Rename
ps <- moving_pictures

ps.gut <- subset_samples(ps, sample_type == "stool")
taxa_names(ps.gut) <- paste0("ASV-", seq(ntaxa(ps.gut)))
# remove asvs which are zero in all of these samples
ps.gut <- prune_taxa(taxa_sums(ps.gut) > 0, ps.gut)

# remove samples with less than 500 reads
ps.gut <- prune_samples(sample_sums(ps.gut) > 500, ps.gut)

# Covnert to relative abundances
ps.gut.rel <- microbiome::transform(ps.gut, "compositional")

ps.ord <- ordinate(ps.gut.rel, "PCoA")

ordip <- plot_ordination(ps.gut.rel, ps.ord, justDF = T)

# Get axis 1 and 2 variation
evals1 <- round(ps.ord$values$Eigenvalues[1] / sum(ps.ord$values$Eigenvalues) * 100, 2)
evals2 <- round(ps.ord$values$Eigenvalues[2] / sum(ps.ord$values$Eigenvalues) * 100, 2)

# Visualize
# theme_set(theme_bw(14))
# set colors
subject_cols <- c(F4 = "#457b9d", M3 = "#e63946")

# Add trajectory for given subject
dfs <- subset(ordip, host_subject_id == "F4")
# arrange according to sampling time
dfs <- dfs %>%
  arrange(days_since_experiment_start)

p <- ggplot(ordip, aes(x = Axis.1, y = Axis.2))
p2 <- p +
  geom_path(
    data = dfs, alpha = 0.5,
    arrow = arrow(
      angle = 15, length = unit(0.1, "inches"),
      ends = "last", type = "closed"
    )
  ) +
  geom_point(aes(color = host_subject_id), alpha = 0.6, size = 3) +
  scale_color_manual("Subject", values = subject_cols) +
  xlab(paste("PCoA 1 (", evals1, "%)", sep = "")) +
  ylab(paste("PCoA 2 (", evals2, "%)", sep = "")) +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  )
# coord_fixed(sqrt(evals[2] / evals[1]))

# Print figure
print(p2)

# Alternatively we can just focus on one subject

ps.gut.rel.m3 <- subset_samples(ps.gut.rel, host_subject_id == "M3")
ps.ord.m3 <- ordinate(ps.gut.rel.m3, "PCoA")

ordip.m3 <- plot_ordination(ps.gut.rel.m3, ps.ord.m3, justDF = T)

# Get axis 1 and 2 variation
evals1 <- round(ordip.m3$values$Eigenvalues[1] / sum(ordip.m3$values$Eigenvalues) * 100, 2)
evals2 <- round(ordip.m3$values$Eigenvalues[2] / sum(ordip.m3$values$Eigenvalues) * 100, 2)


# arrange according to sampling time
ordip.m3 <- ordip.m3 %>%
  arrange(days_since_experiment_start) # important to arrange the time

# Visualize
# blank plot initiate
p1 <- ggplot(ordip.m3, aes(x = Axis.1, y = Axis.2))
# add layers
p3 <- p1 +
  # add arrows with geom_path
  geom_path(alpha = 0.5, arrow = arrow(
    angle = 30, length = unit(0.1, "inches"),
    ends = "last", type = "closed"
  )) +
  # add points
  geom_point(aes(color = days_since_experiment_start), size = 3) +
  # add gradient colors
  scale_color_viridis("Days from first sampling") +
  # add x and y labels
  xlab(paste("PCoA 1 (", evals1, "%)", sep = "")) +
  ylab(paste("PCoA 2 (", evals2, "%)", sep = "")) +
  # remove grids in the plot
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  )

print(p3)
