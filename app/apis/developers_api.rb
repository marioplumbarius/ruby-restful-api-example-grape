module Developers
  class API < Grape::API
    helpers PaginationHelper
    helpers DevelopersCacheHelper

    def self.id_requirement
      /[0-9]*/
    end

    resource :developers do

      desc 'Returns all developers', entity: Entities::Developer, is_array: true
      params do
        use :pagination
      end
      get '/' do
        @developers = Developer.page(params[:page]).per(params[:per_page])

        @developers
      end

      desc 'Creates a new developer'
      params do
        requires :all, using: Entities::Params::Developer.documentation
      end
      post '/' do
        @developer = Developer.new(params)

        @developer.save!
      end

      desc 'Returns the developer with the provided :id', entity: Entities::Developer
      params do
        requires :id, type: Integer, desc: 'the id of the developer', documentation: { param_type: 'path' }
      end
      get ':id', requirements: { id: @@id_requirement } do
        @developer = Providers::RedisProvider.get "#{@@cache_key_prefix}#{params[:id]}"

        if @developer.blank?
          @developer = Developer.find(params[:id])

          Providers::RedisProvider.set "#{@@cache_key_prefix}#{params[:id]}", @developer, @@cache_expiration
        end

        @developer
      end

      desc 'Updates the developer with the provided :id'
      params do
        optional :all, using: Entities::Params::Developer.documentation
        requires :id, type: Integer, desc: 'the id of the developer', documentation: { param_type: 'path' }
      end
      patch ':id', requirements: { id: @@id_requirement } do
        @developer = Developer.update(params[:id], params)

        if @developer.valid?
          Providers::RedisProvider.del "#{@@cache_key_prefix}#{params[:id]}"
          status 204
        else
          fail ActiveRecord::RecordInvalid, @developer
        end
      end

      desc 'Deletes the developer with the provided :id'
      params do
        requires :id, type: Integer, desc: 'the id of the developer', documentation: { param_type: 'path' }
      end
      delete ':id', requirements: { id: @@id_requirement } do
        number_affected_rows = Developer.delete(params[:id])

        if number_affected_rows == 0
          status 404
        else
          Providers::RedisProvider.del "#{@@cache_key_prefix}#{params[:id]}"
          status 204
        end
      end
    end
  end
end
