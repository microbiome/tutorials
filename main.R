library(rmarkdown)
fs <- list.files(pattern = ".Rmd$")
fs <- sample(fs)
fs <- setdiff(fs, c("info.Rmd", "misc.Rmd"))
for (f in fs) {
  print(f)
  render(f, output_format = "html_document")
}
