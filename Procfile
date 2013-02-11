web: bundle exec puma -p $PORT -t 1:5 -e $RACK_ENV
worker: bundle exec sidekiq -e $RACK_ENV -C config/sidekiq.yml
