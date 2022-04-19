suppressMessages(source("setup.R", echo = FALSE))

args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
  stop("Rscript generate_playlist_report.R --args SPOTIFY_URL_FOR_PLAYLIST")
} else {
  url = args[2]
}

playlist_id = str_match(url,"/([A-z0-9]+)\\?")[2]

df = data.frame(get_playlist_audio_features(playlist_uris=playlist_id))

name = df[1,"playlist_name"]
filename = paste0("Reports/",str_replace_all(tolower(name)," ", "_"), ".csv")

features_df = select(df, c("track.name","track.id","danceability","energy","speechiness","liveness","valence"))
dir.create("Reports",showWarnings = FALSE)
write.csv(features_df, filename)
message(paste0("\nCreated report for the playlist ", name, " in '", filename, "'\n"))