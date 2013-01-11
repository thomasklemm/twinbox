# Twitter REST API Client Setup
Twitter.configure do |config|
  config.consumer_key       = ENV['TWITTER_READ_CONSUMER_KEY']
  config.consumer_secret    = ENV['TWITTER_READ_CONSUMER_SECRET']
  config.oauth_token        = ENV['TWITTER_READ_OAUTH_TOKEN']
  config.oauth_token_secret = ENV['TWITTER_READ_OAUTH_TOKEN_SECRET']
end
