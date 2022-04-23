suppressPackageStartupMessages(source("shared_library.R"))

url = user.input("Target playlist URL: ")

uri = uri_from_url(url)

playlist_features = get_playlist_df(uri)

name = get_playlist(uri)$name
message(paste0("Got audio features for the playlist '", name, "'"))

dir.create("Reports", showWarnings = FALSE)
filename = paste0("Reports/playlist_", str_replace_all(tolower(name), " ", "_"), ".csv")
write.csv(playlist_features, filename)
message(paste0(
  "Created report for the playlist '",
  name,
  "' in '",
  filename,
  "'\n"
))
