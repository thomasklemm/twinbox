source 'https://rubygems.org'

# Ruby Version on Heroku
ruby '1.9.3'

# Mongoid (ORM for MongoDB)
gem 'bson_ext'
gem 'mongoid', '~> 3.0.0'

# Puma (App Server)
gem 'puma', '>= 2.0.0.b6'

# Rails
gem 'rails', '3.2.12'

# jQuery Rails (jQuery Adapter for Rails)
gem 'jquery-rails'

# High Voltage (Static Pages)
gem 'high_voltage'

# Slim (Templating)
gem 'slim-rails'

# Twitter (Twitter API Client)
gem 'twitter'

# TweetStream (Twitter Streaming API Client)
gem 'tweetstream'

# HTTPClient (MT-Safe HTTP Client)
gem 'httpclient'

# Redcarpet (Markdown Parser)
gem 'redcarpet'

# Devise (User Authentication)
gem 'devise'

# Omniauth for Twitter (oAuth Authentication)
gem 'omniauth-twitter'

# Sidekiq & Sinatra (for Sidekiq Web Interface)
gem 'kiqstand'
gem 'sidekiq'
gem 'sinatra', :require => false

# Cache Digests (Watch Progress of this gem!)
gem 'cache_digests'

# Figaro (Managing credentials)
gem 'figaro'

# New Relic (Server Monitoring)
gem 'newrelic_rpm'

# Lograge
gem 'lograge'

# Production Gems
group :production do
  # Memcached on Heroku
  gem 'memcachier'
  gem 'dalli'
end

# Gems used only for assets and not required
#   in production environments by default.
group :assets do
  # Stylesheets
  # Sass
  gem 'sass', '>= 3.2.1'
  gem 'sass-rails'

  # Compass
  gem 'compass-rails'

  # Bourbon (SASS Mixins)
  gem 'bourbon'

  # Neat (Semantic Grids)
  gem 'neat'

  # Javascripts
  gem 'coffee-rails'
  gem 'uglifier'
end

# Development Gems
group :development do
  # Heroku (Custom Deployment Rake Tasks)
  gem 'heroku'
  # gem 'taps'    # for rake production:pull_db, has outdated dependencies
  # gem 'sqlite3' # for rake production:pull_db, has outdated dependencies

  # Pry (IRB Replacement)
  gem 'pry-rails'
  gem 'pry-remote'

  # Letter Opener (Preview ActionMailer Emails in Development)
  gem 'letter_opener'

  # Quiet Assets (Mute Asset Log Messages in Development)
  gem 'quiet_assets'

  # Better Errors (REPL Debug)
  gem 'better_errors'
  gem 'binding_of_caller'
end
