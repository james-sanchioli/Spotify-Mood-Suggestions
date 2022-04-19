suppressPackageStartupMessages(source("setup.R"))

reachedEnd = FALSE
dx = 0
user_library = data.frame()

message("\nRetrieving user library")
while (!reachedEnd) {
  df = data.frame(get_my_saved_tracks(limit = 50,
                                      offset = dx))
  if (nrow(df) == 0) {
    message(paste("  Terminated query with", nrow(user_library), "total songs"))
    reachedEnd = TRUE
  } else {
    user_library = rbind(user_library, df)
    message(paste(
      "  Grabbed chunk",
      dx / 50,
      "with",
      nrow(df),
      "songs and",
      nrow(user_library),
      "total songs"
    ))
    dx = dx + 50
  }
}
user_library = select(user_library, c("track.id", "track.name"))

user_library_features = data.frame()

message("\nRetrieving track features")
for (r in seq(1, nrow(user_library), 100)) {
  df = get_track_audio_features(user_library[r:(min(r + 100 - 1, nrow(user_library))), "track.id"])
  df = select(df,
              c(
                "id",
                "danceability",
                "energy",
                "speechiness",
                "liveness",
                "valence"
              ))
  message(paste(
    "  Grabbed chunk",
    (r - 1) / 100 + 1,
    "at",
    r + nrow(df) - 1,
    "/",
    nrow(user_library),
    "total songs"
  ))
  user_library_features = rbind(user_library_features, df)
}

user_library = merge(
  user_library,
  user_library_features,
  by.x = "track.id",
  by.y = "id",
  all.x = TRUE
)

name = get_my_profile()$display_name
filename = paste0("Reports/", str_replace_all(tolower(name), " ", "_"), ".csv")

dir.create("Reports", showWarnings = FALSE)
write.csv(user_library, filename)
message(paste0("\nCreated report for the user ", name, " in '", filename, "'\n"))
