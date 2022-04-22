suppressMessages(source("shared_library.R", echo = FALSE))
suppressMessages(library(caret))
suppressMessages(library(e1071))

args = commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  stop("Run 'Rscript suggest_playlist.R --args MOOD LENGTH'",
       call. = FALSE)
} else {
  target_mood = str_to_lower(args[2])
  target_length = args[3]
}

user_library = get_user_library_df()

mood_baseline = read.csv("Reports/angry.csv") %>%
  mutate(mood = "angry")

mood_baseline = read.csv("Reports/excited.csv") %>%
  mutate(mood = "excited") %>%
  rbind(mood_baseline)

mood_baseline = read.csv("Reports/happy.csv") %>%
  mutate(mood = "happy") %>%
  rbind(mood_baseline)

mood_baseline = read.csv("Reports/relaxed.csv") %>%
  mutate(mood = "relaxed") %>%
  rbind(mood_baseline)

mood_baseline = read.csv("Reports/sad.csv") %>%
  mutate(mood = "sad") %>%
  rbind(mood_baseline)


mood_baseline_labels = mood_baseline[,"mood"]

mood_baseline_features = mood_baseline %>%
  select(c("danceability",
           "energy",
           "speechiness",
           "liveness",
           "valence"))

model = train(mood_baseline_features,mood_baseline_labels,'nb',trControl=trainControl(method='cv',number=10))

predict = predict(model$finalModel,newdata = user_library)

user_library = cbind(user_library, predict)

target_column = paste0("posterior.",target_mood)

user_library = user_library[order(user_library[target_column],decreasing = TRUE),]

track_uris = user_library[1:10,"track.id"]

new_playlist_id = create_playlist(user_id = get_my_profile()$id, name = str_to_title(target_mood))$id

add_all_tracks_to_playlist(new_playlist_id, track_uris)
