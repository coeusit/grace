require 'redis'
module Cache
  _redis_url = ENV.has_key?('REDIS_HOST') ? ENV['REDIS_HOST'] : 'redis://redis:6379/0'
  @_redis = Redis.new(url: _redis_url)
  def self.get(_var)
    return @_redis.get(_var)
  end
  def self.set(_key, _var, _expiration = 86400)
    return @_redis.set(_key, _var, ex: _expiration)
  end
  
end
