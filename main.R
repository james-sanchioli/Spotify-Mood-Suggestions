# INSTALLATION
# install.packages('spotifyr', dependencies = TRUE)

uris = c("2ryI0oeYtWavBUlJDP2GVV")

# SCRIPT
get_my_recently_played(authorization=oauth)

df = data.frame(get_playlist_audio_features("jsanchioli", uris, authorization=access_token))
new_df = select(df, c("track.name","danceability","energy","speechiness","liveness","valence"))
write.csv(new_df, "creepy_crawley_breakdown.csv")
