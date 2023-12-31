library(httr)

bearer_token <- Sys.getenv("BEARER_TOKEN")
headers = c(
  `Authorization` = sprintf('Bearer %s', bearer_token)
)


params = list(
  `query` = 'from:TwitterDev',
  `max_results` = '10',
  `tweet.fields` = 'created_at,lang,conversation_id'
)


response <- httr::GET(url = 'https://api.twitter.com/2/tweets/search/recent', httr::add_headers(.headers=headers), query = params, verbose())


recent_search_body <-
  content(
    response,
    as = 'parsed',
    type = 'application/json',
    simplifyDataFrame = TRUE
  )