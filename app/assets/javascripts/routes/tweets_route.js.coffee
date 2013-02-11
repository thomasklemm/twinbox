App.TweetsRoute = Em.Route.extend(
  model: () ->
    return App.Tweet.find()
)
