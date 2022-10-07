require 'securerandom'
require 'openssl'
require 'redis'

class Session
  @_sid = nil
  @_uuid = nil
  @_redis = nil
  def renew_session
    set_admin(is_admin)
    set_user_id(user_id)
    set_auth(authenticated)
    set_key(key)
  end
  def set_admin(_a)
    @_redis.set("session/#{@_uuid}/admin", _a, ex: session_expiration)
  end
  def is_admin
    return @_redis.get("session/#{@_uuid}/admin")
  end
  def set_user_id(_k)
    @_redis.set("session/#{@_uuid}/user_id", _k, ex: session_expiration)
  end
  def user_id
    return @_redis.get("session/#{@_uuid}/user_id")
  end
  def set_auth(_auth_status)
    @_redis.set("session/#{@_uuid}/authenticated", _auth_status, ex: session_expiration)
  end
  def authenticated
    return @_redis.get("session/#{@_uuid}/authenticated")
  end
  def set_uuid(_uuid)
    @_uuid = _uuid
  end
  def uuid
    return @_uuid
  end
  def verify_key(_uuid,_key)
    return @_redis.get("session/#{_uuid}/key") == _key
  end
  def key
    return @_redis.get("session/#{@_uuid}/key")
  end
  def set_key(_key)
    @_redis.set("session/#{@_uuid}/key", _key, ex: session_expiration)
  end
  def delete_session
    @_redis.del("session/#{@_uuid}/user_id")
    @_redis.del("session/#{@_uuid}/admin")
    @_redis.del("session/#{@_uuid}/key")
    @_redis.del("session/#{@_uuid}/authenticated")
  end
  def session_expiration
    return ENV.has_key?('SESSION_EXPIRATION') ? ENV['SESSION_EXPIRATION'] : 86400
  end
  def initialize(opt)
    if !opt.has_key?(:redis)
      _redis_url = ENV.has_key?('REDIS_HOST') ? ENV['REDIS_HOST'] : 'redis://redis:6379/0'
    else
      _redis_url = opt[:redis]
    end
    @_redis = Redis.new(url: _redis_url)
    if opt.has_key?(:sid)
      @_sid = opt[:sid]
    end
    if opt.has_key?(:session_id) && opt.has_key?(:session_key) && verify_key(opt[:session_id], opt[:session_key])
      set_uuid(opt[:session_id])
      set_key(opt[:session_key])
    else
      set_uuid(SecureRandom.uuid)
      set_key(SecureRandom.hex(16))
    end
  end
  def deauth
    set_auth(false)
    set_user_id(nil)
  end
end
