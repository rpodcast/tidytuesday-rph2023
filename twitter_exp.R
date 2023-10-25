# hello world example with the users endpoint

library(httr2)
library(tibblify)
library(lubridate)

bearer_token <- Sys.getenv("BEARER_TOKEN")
headers <- c(`Authorization` = sprintf('Bearer %s', bearer_token))

params <- list(
  `user.fields` = 'description',
  `expansions` = 'pinned_tweet_id'
)

handle <- 'theRcast'
url_handle <- sprintf('https://api.twitter.com/2/users/by?usernames=%s', handle)
#url_handle <- 'https://api.twitter.com/2/users/me'

req <- request(url_handle)

req <- req |>
  req_url_query(user.fields = 'description', expansions = 'pinned_tweet_id') |>
  req_headers(
    Authorization = sprintf('Bearer %s', bearer_token)
  )

resp <- req |>
  req_perform()

resp_status_desc(resp)

resp |>
  resp_body_json() 

# using the search endpoint: goal is to grab #tidytuesday tweets in a range

# create timestamp 
test <- "2023-10-23T00:10:16-08:00"
z <- as.POSIXct(test,format="%Y-%m-%dT%H:%M:%OS")
start_time <- strftime(z, "%Y-%m-%dT%H:%M:%SZ")
start_time


 tm <- as.POSIXlt(Sys.time(), "UTC")
 strftime(tm , "%Y-%m-%dT%H:%M:%S%z")

query_string <- '#tidytuesday (has:media) -is:retweet'
query_string <- '#tidytuesday -is:retweet has:images'

req <- request("https://api.twitter.com/2/tweets/search/recent") |>
  req_url_query(
    query = query_string,
    max_results = 20,
    #start_time = I(start_time),
    #tweet_fields = "lang",
    media.fields = "url",
    expansions = "attachments.media_keys"
  ) |>
  #req_url_path_append(max_results = 1) |>
  #req_url_path_append("query=#tidytuesday") |>
  req_headers(
    Authorization = sprintf('Bearer %s', bearer_token)
  )

req_dry_run(req)

resp <- req |>
  req_perform()

resp_status(resp)

resp_json_raw <- resp |>
  resp_body_json()

View(resp_json_raw)

resp_df <- tibblify(resp_json_raw)$data

resp_df$text[1]
