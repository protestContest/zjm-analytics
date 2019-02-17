web: rails server -p $PORT
worker: bundle exec sidekiq -t 25 -c 3 -q default -q mailers