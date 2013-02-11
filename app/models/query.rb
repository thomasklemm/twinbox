# == Schema Information
#
# Table name: queries
#
#  company_id         :integer
#  created_at         :datetime         not null
#  id                 :integer          not null, primary key
#  max_tweet_id       :integer
#  query_type         :text
#  term               :text
#  twitter_account_id :integer
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_queries_on_company_id          (company_id)
#  index_queries_on_twitter_account_id  (twitter_account_id)
#

class Query
  belongs_to :company
  belongs_to :twitter_account

  # Every query has a company, either directly or through the Twitter account
  alias_method :pure_company, :company
  def company
    pure_company || twitter_account.company
  end

  # Every query has a Twitter account, either directly or as a random one
  # of the company's authenticated accounts
  alias_method :pure_twitter_account, :twitter_account
  def twitter_account
    pure_twitter_account || company.twitter_accounts.sample
  end

  # Initialize a new twitter client for the query
  def twitter_client
    @client ||= Twitter::Client.new(oauth_token: twitter_account.token, oauth_token_secret: twitter_account.token_secret)
  end

  def max_tweet_id
    self[:max_tweet_id] || 0
  end

  # QueryTypes
  #  available query_types: :mentions, :search
  classy_enum_attr :query_type
  delegate :enqueue!, to: :query_type
  delegate :perform!, to: :query_type

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

  attr_accessible :query_type, :term, :last_performed_at, :last_scheduled_at, :max_tweet_id
end
