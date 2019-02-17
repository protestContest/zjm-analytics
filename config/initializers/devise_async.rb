Devise::Async.setup do |config|
  config.backend = :sidekiq

  if Rails.env == 'production'
    config.queue = :zjm-analytics_production_mailers
  else
    config.queue   = :mailer
  end
end
