class OmniauthController < ApplicationController
  before_filter :authenticate_user!

  # Handle the omniauth callback from Twitter
  def twitter
    auth = request.env['omniauth.auth']
    current_user.company.create_or_update_twitter_account(auth)

    flash.notice = 'Authorized Twitter account successfully.'
    redirect_to edit_user_registration_path
  end

  # Handle failed omniauth authorization requests
  def failure
    flash.alert = 'Failed to authorize Twitter account.'
    redirect_to edit_user_registration_url
  end
end
