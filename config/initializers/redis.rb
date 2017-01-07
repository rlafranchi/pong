require 'redis'

begin
  if Rails.env.production?
    uri = URI.parse(ENV["REDISTOGO_URL"])
    $redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  else
    $redis = Redis.new(:host => Rails.configuration.redis_host, :port => Rails.configuration.redis_port)
  end
rescue Exception => e
  Rails.logger.error e.backtrace
end
