suppressPackageStartupMessages(source("shared_library.R"))

url = user.input("Target playlist URL: ")

playlist_uri = str_match(url, "/([A-z0-9]+)\\?")[2]

playlist_features = tryCatch({
  get_playlist_df(playlist_uri)
}, error = function(e) {
  stop(
    # Catches a malformed or private spotify URL
    "Enter a correct Spotify URL",
    call. = FALSE
  )
})

name = get_playlist(playlist_uri)$name
message(paste0("Got audio features for the playlist '", name, "'"))

dir.create("Reports", showWarnings = FALSE)
filename = paste0("Reports/playlist_", str_replace_all(tolower(name), " ", "_"), ".csv")
write.csv(playlist_features, filename)
message(paste0(
  "\nCreated report for the playlist '",
  name,
  "' in '",
  filename,
  "'\n"
))
