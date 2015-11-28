module DevelopersCacheHelper

  def cache_key_prefix
    APP_CONFIG['helpers']['developers_helper']['cache_key_prexis']
  end

  def cache_expiration
    APP_CONFIG['helpers']['developers_helper']['cache_expiration']
  end

  # def redis_provider
  #   Providers::RedisProvider.new logger
  # end
end
