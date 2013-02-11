App.IndexRoute = Em.Route.extend(
  redirect: () ->
    this.transitionTo('tweetsIndex')
)
