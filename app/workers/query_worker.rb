class QueryWorker
  include Sidekiq::Worker

  # Perform a certain query
  def perform(query_id)
    query = Query.find(query_id)
    query.perform!
  end
end
