Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://127.0.0.1:6379' }
  if Rails.env.production?
    uri = URI.parse(ENV['REDIS_URL'])
    REDIS = Redis.new(host: uri.host, port: uri.port, password: uri.password)
    config.redis = REDIS
  end
end

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://127.0.0.1:6379' }

  if Rails.env.production?
    uri = URI.parse(ENV['REDIS_URL'])
    REDIS = Redis.new(host: uri.host, port: uri.port, password: uri.password)
    config.redis = REDIS
  end
end
