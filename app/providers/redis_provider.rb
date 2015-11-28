module Providers
  class RedisProvider

    def initialize(logger)
      @redis = Redis.new
      @logger = logger
    end

    def get(key, silent = true)
      @logger.info "redis.get=#{key}"
      @redis.get key
    rescue Redis::CannotConnectError => e
      @logger.warn "redis.get=#{key}, error=#{e.message}"
      raise e unless silent
    end

    def set(key, value, ex, silent = true)
      @logger.info "redis.set=#{key}"
      @redis.set key, value, ex: ex
    rescue Redis::CannotConnectError => e
      @logger.warn "redis.set=#{key}, error=#{e.message}"
      raise e unless silent
    end

    def del(key, silent = true)
      @logger.info "redis.del=#{key}"
      @redis.del key
    rescue Redis::CannotConnectError => e
      @logger.warn "redis.del=#{key}, error=#{e.message}"
      raise e unless silent
    end
  end
end
