=begin
Sidekiq.configure_client do |config|
  if Rails.env.production?
    uri = URI.parse(ENV['REDIS_URL'])
    config.redis = Redis.new(host: uri.host, port: uri.port, password: uri.password)
  else
    config.redis = { url: 'redis://127.0.0.1:6379' }
  end
end

Sidekiq.configure_server do |config|
  if Rails.env.production?
    uri = URI.parse(ENV['REDIS_URL'])
    config.redis = Redis.new(host: uri.host, port: uri.port, password: uri.password)
  else
    config.redis = { url: 'redis://127.0.0.1:6379' }
  end
end
=end
