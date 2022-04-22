suppressMessages(source("shared_library.R", echo = FALSE))
library(recommender)

args = commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  stop(
    "Run 'Rscript suggest_playlist.R --args TARGET_NAME LENGTH'",
    call. = FALSE
  )
} else {
  target_filename = args[2]
  target_length = args[3]
}

training_data = read.csv(target_filename)
target_data = get_user_library_df()

model <- Recommender(training_data, method = "LIBMF")
predictions <- predict(model, target_data, n = target_length)
as(predictions, "list")
