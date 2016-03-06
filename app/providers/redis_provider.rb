module Providers
  class RedisProvider

    def initialize(logger)
      @redis = Redis.new(:host => ENV['REDIS_HOST'], :port => ENV['REDIS_PORT'])
      @logger = logger

      @logger.debug 'initialized redis provided'
    end

    def get(key, silent = true)
      data = @redis.get key
      @logger.info "redis.get=#{key}"
      data
    rescue Redis::CannotConnectError => e
      @logger.warn "redis.get=#{key}, error=#{e.message}"
      raise e unless silent
    end

    def set(key, value, ex, silent = true)
      @redis.set key, value, ex: ex
      @logger.info "redis.set=#{key}"
    rescue Redis::CannotConnectError => e
      @logger.warn "redis.set=#{key}, error=#{e.message}"
      raise e unless silent
    end

    def del(key, silent = true)
      @redis.del key
      @logger.info "redis.del=#{key}"
    rescue Redis::CannotConnectError => e
      @logger.warn "redis.del=#{key}, error=#{e.message}"
      raise e unless silent
    end
  end
end
