class Scheduler
  include Sidekiq::Worker

  def perform
    # Retrieve timelines for each twitter account
    retrieve_home_timelines
    retrieve_mention_timelines
  end

  def retrieve_home_timelines
    TwitterAccount.all.each do |t|
      tweets = t.twitter_client.home_timeline
      Tweet.from_twitter(t.project, tweets, source: :home_timeline)
    end
  end

  def retrieve_mentions_timelines
    TwitterAccount.all.each do |t|
      tweets = t.twitter_client.mentions_timeline
      Tweet.from_twitter(t.project, tweets, source: :mentions_timeline)
    end
  end
end
