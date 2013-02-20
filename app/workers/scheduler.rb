class Scheduler
  include Sidekiq::Worker

  def perform
    # Retrieve timelines for each twitter account
    retrieve_user_timelines
    retrieve_mentions_timelines
  end

  # The user timeline carries all tweets that the authenticating user has sent
  def retrieve_user_timelines
    TwitterAccount.all.each do |t|
      tweets = t.twitter_client.user_timeline
      Tweet.from_twitter(t.project, tweets, source: :user_timeline)
    end
  end

  def retrieve_mentions_timelines
    TwitterAccount.all.each do |t|
      tweets = t.twitter_client.mentions_timeline
      Tweet.from_twitter(t.project, tweets, source: :mentions_timeline)
    end
  end
end
