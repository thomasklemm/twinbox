##
# QueryTypes
class QueryType
  owner :query

  # Enqueue query to be performed asynchronously
  def enqueue!
    QueryWorker.perform_async(query.id)
  end

  # Store maximum tweet id in query results,
  # to minimize database requests and transfering of unnescessary data
  def set_new_max_tweet_id(tweets)
    new_max_id = tweets.map(&:id).max || 0 # zero in case no new records returned
    query.max_tweet_id = [query.max_tweet_id, new_max_id].max
    query.save
  end
end

##
# Mentions
class QueryType::Mentions < QueryType
  # Perform a mentions query
  def perform!
    opts = {count: 100}
    opts[:since_id] = query.max_tweet_id if query.max_tweet_id.present?
    tweets = query.twitter_client.mentions_timeline(opts)
    Tweet.create_tweets(tweets, query.company)
    set_new_max_tweet_id(tweets)
  end
end

##
# Search
class QueryType::Search < QueryType
  # Perform a search query
  def perform!
    opts = {count: 100}
    opts[:since_id] = query.max_tweet_id if query.max_tweet_id.present?
    tweets = query.twitter_client.search(query.term, opts).results
    Tweet.create_tweets(tweets, query.company)
    set_new_max_tweet_id(tweets)
  end
end
