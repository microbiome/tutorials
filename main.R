library(rmarkdown)
fs <- list.files(pattern = ".Rmd$")
fs <- sample(fs)
fs <- setdiff(fs, c("info.Rmd", "misc.Rmd", "all.Rmd"))
#fs <- setdiff(fs, c("Betadiversity.Rmd"))
#fs <- setdiff(fs, c("CompositionAmplicondata.Rmd"))
#fs <- setdiff(fs, c("Composition.Rmd"))
#fs <- setdiff(fs, c("Diversity.Rmd"))
fs0 <- fs
rem <- fs
for (myrmdfile in rem) {
  print(myrmdfile)
  render(myrmdfile, output_format = "html_document")
  print(paste(myrmdfile, "has been rendered"))
  rem <- setdiff(rem, myrmdfile) # Remaining files to handle
}
