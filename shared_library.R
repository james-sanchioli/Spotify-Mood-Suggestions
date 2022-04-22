suppressPackageStartupMessages(source("setup.R"))

get_playlist_df = function(uris) {
  message("\nBegin getting playlist audio features")
  playlist_features = data.frame(get_playlist_audio_features(playlist_uris = uris)) %>%
    select(
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
  
  message(paste(
    "Terminated query with",
    nrow(playlist_features)
  ))
  
  return(playlist_features)
}


get_user_library_df = function() {
  message("\nBegin getting user library audio features")
  reachedEnd = FALSE
  dx = 0
  user_library = data.frame()
  while (!reachedEnd) {
    df = data.frame(get_my_saved_tracks(limit = 50,
                                        offset = dx))
    if (nrow(df) == 0) {
      message(paste(
        "  Terminated query with",
        nrow(user_library),
        "total songs"
      ))
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
  
  merge(
    user_library,
    user_library_features,
    by.x = "track.id",
    by.y = "id",
    all.x = TRUE
  ) %>%
    return
}

add_all_tracks_to_playlist = function(playlist_id, uris, authorization = get_spotify_authorization_code()) {
  for (r in seq(1, length(uris), 100)) {
    add_tracks_to_playlist(playlist_id, uris[r:(min(r + 100 - 1, length(uris)))])
  }
}

user.input <- function(prompt) {
  if (interactive()) {
    return(readline(prompt))
  } else {
    cat(prompt)
    return(readLines("stdin", n=1))
  }
}
