##
# QueryTypes
class QueryType < ClassyEnum::Base
  owner :query

  # Enqueue query to be performed asynchronously
  def enqueue!
    QueryWorker.perform_async(query.id)
  end

  # Store maximum tweet id in query results,
  # to minimize database requests and transfering of unnescessary data
  def set_new_max_tweet_id(tweets)
    new_max_id = tweets.map(&:id).max
    query.max_tweet_id = [query.max_tweet_id, new_max_id].max
    query.save
  end
end

##
# Mentions
class QueryType::Mentions < QueryType
  # Perform a mentions query
  def perform!
    tweets = query.twitter_client.mentions_timeline(count: 200, since_id: query.max_tweet_id)
    Tweet.create_tweets(tweets)
    set_new_max_tweet_id(tweets)
  end
end

##
# Search
class QueryType::Search < QueryType
  # Perform a search query
  def perform!
    tweets = query.twitter_client.search(query.term, count: 100, since_id: query.max_tweet_id)
    Tweet.create_tweets(tweets)
    set_new_max_tweet_id(tweets)
  end
end
