path <- "C:/Users/Stefan/OneDrive - Norwegian University of Life Sciences/Gasto/"
source(paste0(path, "src/help_functions.R"))
rmarkdown::render(paste0(path, 'Experiment_1.Rmd'), 'html_document')
rmarkdown::render(paste0(path, 'Experiment_2.Rmd'), 'html_document')
