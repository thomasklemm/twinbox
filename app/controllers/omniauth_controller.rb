class OmniauthController < ApplicationController
  before_filter :authenticate_user!

  # Handle the omniauth callback from Twitter
  def callback
    auth = request.env['omniauth.auth']
    company = current_user.company
    company.create_or_update_twitter_account(auth)
    redirect_to edit_user_registration_path
  end

  # Setup the Omniauth request with matching application consumer details
  # for the permissions required (read-only or read-and-write)
  def setup
    request.env['omniauth.strategy'].options[:consumer_key]    = twitter_application[:consumer_key]
    request.env['omniauth.strategy'].options[:consumer_secret] = twitter_application[:consumer_secret]

    render text: 'Omniauth setup phase', status: 404
  end

protected

  # Return consumer details for requested permissions scope
  def twitter_application
    if params[:permissions] == 'write'
      { consumer_key:    ENV['TWITTER_WRITE_CONSUMER_KEY'],
        consumer_secret: ENV['TWITTER_WRITE_CONSUMER_SECRET'] }
    else
      { consumer_key:    ENV['TWITTER_READ_CONSUMER_KEY'],
        consumer_secret: ENV['TWITTER_READ_CONSUMER_SECRET'] }
    end
  end

end
