Sidekiq.configure_server do |config|
  # Poll interval for scheduled jobs in seconds. Default: 15
  config.poll_interval = 5
end
