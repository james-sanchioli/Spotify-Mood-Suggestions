suppressPackageStartupMessages(source("setup.R"))

args = commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  stop("Run 'Rscript generate_playlist_report.R --args SPOTIFY_URL_FOR_PLAYLIST'", call. = FALSE)
} else {
  url = args[2]
}

playlist_id = str_match(url, "/([A-z0-9]+)\\?")[2]

message("\nBegin getting audio features")
df = tryCatch({
  data.frame(get_playlist_audio_features(playlist_uris = playlist_id))
}, error = function(e) {
    stop("Run 'Rscript generate_playlist_report.R --args SPOTIFY_URL_FOR_PLAYLIST'", call. = FALSE)
  }
)

name = df[1, "playlist_name"]
message(paste0("Got audio features for the playlist '", name, "'"))

features_df = select(
  df,
  c(
    "track.name",
    "track.id",
    "danceability",
    "energy",
    "speechiness",
    "liveness",
    "valence"
  )
)

dir.create("Reports", showWarnings = FALSE)
filename = paste0("Reports/", str_replace_all(tolower(name), " ", "_"), ".csv")
write.csv(features_df, filename)
message(paste0(
  "\nCreated report for the playlist '",
  name,
  "' in '",
  filename,
  "'\n"
))