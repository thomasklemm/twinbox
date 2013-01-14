Sidekiq.configure_server do |config|
  # Poll interval for scheduled jobs in seconds. Default: 15
  config.poll_interval = 5

  # Configure database pool size
  database_url = ENV['DATABASE_URL']
  if(database_url)
    ENV['DATABASE_URL'] = "#{database_url}?pool=25"
    ActiveRecord::Base.establish_connection
  end

end
