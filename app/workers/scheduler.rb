class Scheduler
  include Sidekiq::Worker
  sidekiq_options queue: :scheduling

  # Enqueue each query execution when running
  # and schedule next run of self
  def perform
    schedule_next_run
    enqueue_queries
  end

  # Run scheduler once per minute,
  # schedule next run
  def schedule_next_run
    Scheduler.perform_in(1.minute)
  end

  # Find queries that have not been run in the last
  def enqueue_queries
    Query.find_each(&:enqueue!)
  end
end
