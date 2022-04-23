suppressMessages(library(R.utils))
args = commandArgs(trailingOnly = TRUE, asValues = TRUE, adhoc = TRUE)
message(paste(names(args), args, sep = ": ", collapse = "\n"))