# == Schema Information
#
# Table name: tweets
#
#  company_id       :integer
#  created_at       :datetime         not null
#  id               :integer          not null, primary key
#  text             :text
#  tweet_id         :integer
#  updated_at       :datetime         not null
#  user_image_url   :text
#  user_name        :text
#  user_screen_name :text
#
# Indexes
#
#  index_tweets_on_company_id  (company_id)
#

class Tweet
  belongs_to :company

  # Process collection of raw tweets, creating a tweet for each
  def self.create_tweets(raw_tweets, company)
    raw_tweets.each {|raw_tweet| create_tweet(raw_tweet, company)}
  end

  # Map attributes from raw tweet and create tweet
  def self.create_tweet(raw_tweet, company)
    tweet = company.tweets.where(tweet_id: raw_tweet.id).first_or_initialize # Tweet id
    tweet.text = raw_tweet.text # Tweet text
    tweet.user_name = raw_tweet.user.name # Sender's name
    tweet.user_screen_name = raw_tweet.user.screen_name # Sender's screen_name
    tweet.user_image_url = raw_tweet.user.profile_image_url # Sender's profile_image_url
    tweet.created_at = raw_tweet.created_at.utc # set created_at to Twitter's created_at
    tweet.save
  end

  attr_accessible :text, :tweet_id, :user_name, :user_screen_name
end
