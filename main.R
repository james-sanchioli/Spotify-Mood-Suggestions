# INSTALLATION
install.packages('spotifyr', dependencies = TRUE)

# STARTUP
library(spotifyr)
library(knitr)
library(dplyr)

Sys.setenv(SPOTIFY_CLIENT_ID = '8be2402f0a3b40bd9f636bd95ef2711d')
Sys.setenv(SPOTIFY_CLIENT_SECRET = 'b8112b6d16da4cf0ae0d8f13a3ac0cbc')
access_token = get_spotify_access_token()

scopes = c(
  "user-library-read",
  "user-read-recently-played"
)

oauth = get_spotify_authorization_code(scope = scopes)

# uris = c("45i51TCBS6sxl33wtMtZm4")
# uris = c("2bJAHjVNPyb0Dsd6iEhBxP")
uris = c("2ryI0oeYtWavBUlJDP2GVV")

# SCRIPT
get_my_recently_played(authorization=oauth)

print(get_playlist("jsanchioli", uris, authorization=access_token))

df = data.frame(get_playlist_audio_features("jsanchioli", uris, authorization=access_token))
new_df = select(df, c("track.name","danceability","energy","speechiness","liveness","valence"))
write.csv(new_df, "creepy_crawley_breakdown.csv")
