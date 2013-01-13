class Scheduler
  include Sidekiq::Worker
  sidekiq_options queue: :scheduling

  # Enqueue each query execution when running
  # and schedule next run of self
  def perform
    schedule_next_run
    enqueue_queries
  end

  # Schedule next run of scheduler
  def schedule_next_run
    Scheduler.perform_in(10.seconds)
  end

  # Find queries that have not been run in the last
  def enqueue_queries
    Query.find_each(&:enqueue!)
  end
end
