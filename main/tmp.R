times <- c()

# Render all files
for (myfile in fs) {

    times[[myfile]] <- system.time(rmarkdown::render(myfile))

}

rmarkdown::render("info.Rmd")
