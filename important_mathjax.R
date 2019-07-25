my_html_document <- function(template = "path_to_custom_template", ...) {
  base_format <- rmarkdown::html_document(...)
  
  template_arg <- which(base_format$pandoc$args == "--template") + 1L
  base_format$pandoc$args[template_arg] <- template
  
  base_format
}
######
my_html_document(template = 'C:/Users/witasa/Seafile/My LibraryImportant7New_microbiome/tutorials')
