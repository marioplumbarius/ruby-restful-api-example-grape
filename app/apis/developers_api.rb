module Developers
  class API < Grape::API
    helpers PaginationParamsHelper
    helpers DevelopersCacheHelper
    helpers PaginationResponseHelper

    def self.id_requirement
      /[0-9]*/
    end

    resource :developers do

      desc 'Returns all developers', entity: Entities::Developer, is_array: true
      params do
        use :pagination
      end
      get '/' do
        @developers = Developer.limit(params[:per_page]).offset(params[:page]*params[:per_page])

        paginate @developers, params[:page], params[:per_page], @developers.count
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
      get ':id', requirements: { id: id_requirement } do
        @developer = redis_provider.get "#{cache_key_prefix}#{params[:id]}"

        if @developer.blank?
          @developer = Developer.find(params[:id])

          redis_provider.set "#{cache_key_prefix}#{params[:id]}", @developer.to_json, cache_expiration
        else
          @developer = JSON.parse @developer
        end

        @developer
      end

      desc 'Updates the developer with the provided :id'
      params do
        optional :all, using: Entities::Params::Developer.documentation
        requires :id, type: Integer, desc: 'the id of the developer', documentation: { param_type: 'path' }
      end
      patch ':id', requirements: { id: id_requirement } do
        @developer = Developer.update(params[:id], params)

        if @developer.valid?
          redis_provider.del "#{cache_key_prefix}#{params[:id]}"
          status 204
        else
          fail ActiveRecord::RecordInvalid, @developer
        end
      end

      desc 'Deletes the developer with the provided :id'
      params do
        requires :id, type: Integer, desc: 'the id of the developer', documentation: { param_type: 'path' }
      end
      delete ':id', requirements: { id: id_requirement } do
        number_affected_rows = Developer.delete(params[:id])

        if number_affected_rows == 0
          status 404
        else
          redis_provider.del "#{cache_key_prefix}#{params[:id]}"
          status 204
        end
      end
    end
  end
end
