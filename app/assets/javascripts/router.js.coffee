App.Router.map (match) ->
  match('/').to('index')
  match('/tweets').to('tweets', (match) ->
    match('/').to('tweetsIndex')
    match('/new').to('addTweet')
    match('/:tweet_id').to('tweet')
    match('/:tweet_id/edit').to('editTweet')
  )
