class Tweet < ActiveRecord::Base
  belongs_to :company

  # Process collection of raw tweets, creating a tweet for each
  def self.create_tweets(raw_tweets)
    raw_tweets.each {|raw_tweet| create_tweet(raw_tweet)}
  end

  # Map attributes from raw tweet and create tweet
  def self.create_tweet(raw_tweet)
    tweet = company.tweets.where(tweet_id: raw_tweet.id).first_or_initialize # Tweet id
    tweet.text = raw_tweet.text # Tweet text
    tweet.user_name = raw_tweet.user.name # Sender's name
    tweet.user_screen_name = raw_tweet.user.screen_name # Sender's screen_name
    tweet.created_at = raw_tweet.created_at.utc # set created_at to Twitter's created_at
    tweet.save
  end

  attr_accessible :text, :tweet_id, :user_name, :user_screen_name
end
