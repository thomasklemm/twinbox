class OmniauthController < ApplicationController
  before_filter :authenticate_user!

  # Handle the omniauth callback from Twitter
  def twitter
    auth = request.env['omniauth.auth']
    project = current_user.account.project
    auth_scope = user_session.delete(:twitter_auth_scope)

    # Create or update twitter account
    twitter_account = TwitterAccount.from_omniauth(auth, project, auth_scope)

    flash.notice = "Account @#{ twitter_account.screen_name } authorized successfully."
    redirect_to project_twitter_account_path(twitter_account)
  end

  # Handle failed omniauth authorization requests
  def failure
    user_session.delete(:twitter_auth_scope)

    flash.alert = 'Failed to authorize Twitter account.'
    redirect_to project_twitter_accounts_path
  end
end
