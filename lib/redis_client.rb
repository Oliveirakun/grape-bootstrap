class RedisClient
  include Singleton
  extend Forwardable

  def_delegators :@redis, :get, :set, :hget, :hgetall, :ping,
                          :ttl, :hincrby, :expire, :del, :flushdb

  def initialize
    @redis = Redis.new(config)
  end

  private

  def config
    {
      host: Config.redis.host,
      port: Config.redis.port,
      password: Config.redis.password
    }
  end
end

