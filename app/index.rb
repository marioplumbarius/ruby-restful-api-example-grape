# rubocop:disable Style/ClassVars

module RESTFul
  class API < Grape::API
    format :json
    prefix :api

    API.logger.formatter = GrapeLogging::Formatters::Default.new
    API.logger.level = APP_CONFIG['logger']['level']['default']
    use GrapeLogging::Middleware::RequestLogger, logger: logger

    @@redis_provider = nil

    helpers do
      def logger
        API.logger
      end

      def redis_provider
        @@redis_provider ||= Providers::RedisProvider.new logger
      end
    end

    rescue_from ActiveRecord::RecordNotFound do
      error!(nil, 404)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      error!({ errors: e.record.errors }, 422)
    end

    rescue_from Grape::Exceptions::ValidationErrors do |e|
      errors = Formatters::Error.format_validation_errors! e

      error!({ errors: errors }, 400)
    end

    mount Developers::API if APP_CONFIG['apis']['developers']['enabled']
    mount Projects::API if APP_CONFIG['apis']['projects']['enabled']

    add_swagger_documentation(
      hide_format: true,
      info:
      {
        title: APP_CONFIG['swagger']['info']['title'],
        description: APP_CONFIG['swagger']['info']['description'],
        contact: APP_CONFIG['swagger']['info']['contact']
      }
    )
  end
end
