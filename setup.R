# STARTUP
library(spotifyr)
library(knitr)
library(dplyr)
library(stringr)

options("httr_oauth_cache" = TRUE)

Sys.setenv(SPOTIFY_CLIENT_ID = '8be2402f0a3b40bd9f636bd95ef2711d')
Sys.setenv(SPOTIFY_CLIENT_SECRET = 'b8112b6d16da4cf0ae0d8f13a3ac0cbc')

token <- get_spotify_access_token()
authorization <- get_spotify_authorization_code()
