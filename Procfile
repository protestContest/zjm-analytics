web: rails server -p $PORT
worker: bundle exec sidekiq -e $RACK_ENV -C config/sidekiq.yml
release: bundle exec rails db:migrate
