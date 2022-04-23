suppressMessages(source("shared_library.R", echo = FALSE))
suppressMessages(library(caret))
suppressMessages(library(e1071))

target_mood = str_to_lower(user.input(prompt = "Target mood: "))
target_length = user.input(prompt = "Playlist length: ")

user_library = tryCatch({
  message("Loading cached user library data")
  read.csv(paste0("Reports/", str_to_lower(get_my_profile()$display_name), ".csv"))
}, error = function(e) {
  message("Requesting user library data")
  get_user_library_df()
})


mood_baseline = read.csv("Baselines/angry.csv") %>%
  mutate(mood = "angry")

mood_baseline = read.csv("Baselines/excited.csv") %>%
  mutate(mood = "excited") %>%
  rbind(mood_baseline)

mood_baseline = read.csv("Baselines/happy.csv") %>%
  mutate(mood = "happy") %>%
  rbind(mood_baseline)

mood_baseline = read.csv("Baselines/relaxed.csv") %>%
  mutate(mood = "relaxed") %>%
  rbind(mood_baseline)

mood_baseline = read.csv("Baselines/sad.csv") %>%
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

track_uris = user_library[1:max(1, target_length),"track.id"]

new_playlist_id = create_playlist(user_id = get_my_profile()$id, name = str_to_title(target_mood))$id

add_all_tracks_to_playlist(new_playlist_id, track_uris)
