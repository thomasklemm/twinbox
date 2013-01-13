##
# QueryTypes
class QueryType < ClassyEnum::Base
  owner :query

  # Enqueue query to be performed asynchronously
  def enqueue!
    QueryWorker.perform_async(query.id)
  end
end

##
# Mentions
class QueryType::Mentions < QueryType
  # Perform a mentions query
  def perform!
    tweets = query.twitter_client.mentions_timeline
  end
end

##
# Search
class QueryType::Search < QueryType
  # Perform a search query
  def perform!
    tweets = query.twitter_client.search(query.term)
  end
end
