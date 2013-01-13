class QueryWorker
  include Sidekiq::Worker

  def perform(query_id)
    query = Query.find(query_id)
    query.perform!
  end
end
