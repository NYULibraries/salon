class RedisObject
  def self.redis
    @connection ||= Redis::Store::Factory.create("#{ENV.fetch('REDIS_HOST','localhost:6379')}", { marshalling: false })
  end

  def self.exists?(id)
    !!redis.get(id)
  end

  def redis
    self.class.redis
  end
end
