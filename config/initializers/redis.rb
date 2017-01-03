require 'redis'

begin
  $redis = Redis.new(:host => Rails.configuration.redis_host, :port => Rails.configuration.redis_port)
rescue Exception => e
  Rails.logger.error e.backtrace
end
