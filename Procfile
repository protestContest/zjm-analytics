web: rails server -p $PORT
worker: bundle exec sidekiq -v -t 25 -c 3 -q default -q mailers