require_relative "#{APP_ROOT}/spec/support/helpers/http_executor_helper"
require_relative "#{APP_ROOT}/spec/support/shared_examples/responses_shared_examples"
require_relative "#{APP_ROOT}/spec/support/shared_examples/api_shared_examples"

describe Developers::API do
  let(:url) { '/api/developers' }
  let(:credentials) do
    APP_CONFIG['middlewares']['auth']['credentials'].map do |username, password|
      response = {
        username: username,
        password: password
      }
      return response
    end
  end

  before do
    basic_authorize credentials[:username], credentials[:password]

    allow_any_instance_of(Providers::RedisProvider).to receive(:set).and_return(nil)
    allow_any_instance_of(Providers::RedisProvider).to receive(:get).and_return(nil)
    allow_any_instance_of(Providers::RedisProvider).to receive(:del).and_return(nil)
  end

  describe 'GET /' do

    let(:developers) { [] }
    let(:params) { { page: Faker::Number.digit, per_page: Faker::Number.digit, format: nil } }
    let(:fetched_developers) { Kaminari.paginate_array(developers).page(params[:page]) }

    before do
      allow(Developer).to receive(:page).and_return(fetched_developers)
      allow(fetched_developers).to receive(:per).and_call_original
      allow(Developers::API).to receive(:paginate).and_return(nil)
    end

    after do
      get url, params
    end

    include_examples :api_with_basic_authentication

    it 'fetches all developers from :page' do
      expect(Developer).to receive(:page).with(params[:page].to_i)
    end

    it 'limits the number of developers per page with param[:per_page]' do
      expect(fetched_developers).to receive(:per).with(params[:per_page].to_i)
    end

    it 'paginates the response body' do
      expect(Developers::API).to receive(:paginate).with(fetched_developers).at_most(1).times
    end

    context 'when no developer is found' do
      let(:developers) { [] }
      let(:fetched_developers) { Kaminari.paginate_array(developers).page(params[:page]) }
      let(:expected_response_body) { fetched_developers.to_json }

      before do
        get url, params
      end

      it 'returns an empty response' do
        expect(last_response.body).to eq expected_response_body
      end

      include_examples :successful_ok_response
    end

    context 'when there are developers found' do
      let(:developers) { build_list :developer, 1 }
      let(:fetched_developers) { Kaminari.paginate_array(developers).page(params[:page]) }
      let(:expected_response_body) { fetched_developers.to_json }

      before do
        get url, params
      end

      it 'returns the developers in the response body' do
        expect(last_response.body).to eq expected_response_body
      end

      include_examples :successful_ok_response
    end
  end

  describe 'POST /' do

    context 'when request body is empty' do
      let(:errors) do
        {
          name: ['is missing'],
          age: ['is missing'],
          github: ['is missing']
        }
      end

      before do
        post url
      end

      after do
        post url
      end

      include_examples :api_with_basic_authentication

      it 'returns missing error for :name field' do
        parsed_body = JSON.parse(last_response.body)
        expect(parsed_body['errors']).to include 'name'
        expect(parsed_body['errors']['name']).to eq errors[:name]
      end

      it 'returns missing error for :age field' do
        parsed_body = JSON.parse(last_response.body)
        expect(parsed_body['errors']).to include 'age'
        expect(parsed_body['errors']['name']).to eq errors[:age]
      end

      it 'returns missing error for :age field' do
        parsed_body = JSON.parse(last_response.body)
        expect(parsed_body['errors']).to include 'github'
        expect(parsed_body['errors']['github']).to eq errors[:github]
      end

      include_examples :unsuccessful_bad_request_response
    end

    context 'when request body is not empty' do
      let(:developer) { build :developer }

      before do
        allow(Developer).to receive(:new).and_return(developer)
        allow(developer).to receive(:save!).and_return(developer)
      end

      after do
        post url, developer.as_json
      end

      it 'builds a new developer' do
        expect(Developer).to receive(:new).with(developer.as_json)
      end

      it 'tries to save the developer' do
        expect(developer).to receive(:save!)
      end

      context 'when the developer is valid' do

        before do
          allow(developer).to receive(:save!).and_call_original

          post url, developer.as_json
        end

        it 'returns the generated id of the developer' do
          parsed_body = JSON.parse last_response.body
          expect(parsed_body).to include 'id'
          expect(parsed_body['id']).to eq developer.id
        end

        include_examples :successful_created_response
      end

      context 'when the developer is invalid' do
        let(:developer) { build :developer, :invalid }

        before do
          allow(developer).to receive(:save!).and_call_original

          post url, developer.as_json
        end

        include_examples :unsuccessful_unprocessable_entity_response
      end
    end
  end

  describe 'GET /:id' do
    context 'when the :id matches the requirements' do
      let(:developer) { build :developer }
      let(:id) { Faker::Number.digit.to_i }
      let(:uri) { url.dup.concat "/#{id}" }
      let(:cache_key_prefix) { "#{Faker::Name.first_name.downcase}:" }
      let(:cache_key) { "#{cache_key_prefix}#{id}" }
      let(:cache_expiration) { Faker::Number.digit }

      before do
        Grape::Endpoint.before_each do |endpoint|
          allow(endpoint).to receive(:cache_key_prefix).and_return(cache_key_prefix)
          allow(endpoint).to receive(:cache_expiration).and_return(cache_expiration)
        end
      end

      after do
        get uri

        Grape::Endpoint.before_each nil
      end

      include_examples :api_with_basic_authentication

      it 'fetches the developer from redis' do
        expect_any_instance_of(Providers::RedisProvider).to receive(:get).with(cache_key)
      end

      context 'when it was found in redis' do
        before do
          allow_any_instance_of(Providers::RedisProvider).to receive(:get).with(cache_key).and_return(developer.to_json)

          get uri
        end

        it 'parses it' do
          expect(JSON).to receive(:parse).with(developer.to_json)
        end

        it 'returns it' do
          expect(last_response.body).to eq developer.to_json
        end

        it 'does not fetch it from database' do
          expect(Developer).not_to receive(:find).with(id)
        end

        it 'does not cache it in redis' do
          expect_any_instance_of(Providers::RedisProvider).not_to receive(:set).with(cache_key, developer.to_json, cache_expiration)
        end

        include_examples :successful_ok_response
      end

      context 'when it was not found in redis' do

        before do
          allow_any_instance_of(Providers::RedisProvider).to receive(:get).with(cache_key).and_return(nil)
        end

        it 'fetches the developer with the provided :id' do
          expect(Developer).to receive(:find).with(id)
        end

        context 'when it exists' do

          before do
            allow(Developer).to receive(:find).with(id).and_return(developer)

            get uri
          end

          after do
            get uri
          end

          it 'caches it in redis' do
            expect_any_instance_of(Providers::RedisProvider).to receive(:set).with(cache_key, developer.to_json, cache_expiration)
          end

          it 'returns it' do
            expect(last_response.body).to eq developer.to_json
          end

          include_examples :successful_ok_response
        end

        context 'when it does not exist' do
          before do
            allow(Developer).to receive(:find).with(id).and_raise(ActiveRecord::RecordNotFound)

            get uri
          end

          it 'returns an empty body' do
            expect(last_response.body).to eq 'null'
          end

          it 'does not cache it in redis' do
            expect_any_instance_of(Providers::RedisProvider).not_to receive(:set).with(cache_key, developer.to_json, cache_expiration)
          end

          it 'does not parse it' do
            expect(JSON).not_to receive(:parse).with(developer)
          end

          include_examples :unsuccessful_not_found_response
        end
      end
    end

    include_examples :api_endpoint_with_id_requirements, ::Helpers::HTTP::METHODS::GET
  end

  describe 'PATCH /:id' do
    context 'when the :id matches the requirements' do
      let(:id) { Faker::Number.digit.to_i }
      let(:developer) { build(:developer) }
      let(:uri) { url.dup.concat "/#{id}" }
      let(:cache_key_prefix) { "#{Faker::Name.first_name.downcase}:" }
      let(:cache_key) { "#{cache_key_prefix}#{id}" }
      let(:cache_expiration) { Faker::Number.digit }

      before do
        Grape::Endpoint.before_each do |endpoint|
          allow(endpoint).to receive(:cache_key_prefix).and_return(cache_key_prefix)
          allow(endpoint).to receive(:cache_expiration).and_return(cache_expiration)
        end
      end

      after do
        get uri

        Grape::Endpoint.before_each nil
      end

      include_examples :api_with_basic_authentication

      context 'when request body is empty' do
        before do
          patch uri
        end

        after do
          patch uri
        end

        it 'does not try to find the developer' do
          expect(Developer).not_to receive(:update)
        end

        it 'does not try to delete the developer from cache' do
          expect_any_instance_of(Providers::RedisProvider).not_to receive(:del).with(:cache_key)
        end

        include_examples :unsuccessful_bad_request_response
      end

      context 'when request body is not empty' do

        before do
          allow(Developer).to receive(:update).with(id, developer.as_json.except('id')).and_return(developer)
        end

        it 'tries to update the developer\'s attributes' do
          expect(Developer).to receive(:update).with(id, developer.as_json.except('id'))

          patch uri, developer.as_json
        end

        context 'when the developer exists' do
          before do
            patch uri, developer.as_json
          end

          after do
            patch uri, developer.as_json
          end

          context 'when it is valid' do

            it 'removes it from redis' do
              expect_any_instance_of(Providers::RedisProvider).to receive(:del).with(cache_key)
            end

            include_examples :successful_no_content_response
          end

          context 'when it is not valid' do
            let(:developer) { build :developer, :invalid }

            it 'does not try to remove it from redis' do
              expect_any_instance_of(Providers::RedisProvider).not_to receive(:del).with(cache_key)
            end

            include_examples :unsuccessful_unprocessable_entity_response
          end
        end

        context 'when the developer does not exist' do
          before do
            allow(Developer).to receive(:update).with(id, developer.as_json.except('id')).and_raise(ActiveRecord::RecordNotFound)

            patch uri, developer.as_json
          end

          after do
            patch uri, developer.as_json
          end

          it 'does not try to remove it from redis' do
            expect_any_instance_of(Providers::RedisProvider).not_to receive(:del).with(cache_key)
          end

          include_examples :unsuccessful_not_found_response
        end
      end
    end

    include_examples :api_endpoint_with_id_requirements, ::Helpers::HTTP::METHODS::PATCH
  end

  describe 'DELETE /:id' do

    context 'when the :id matches the requirements' do
      let(:id) { Faker::Number.digit.to_i }
      let(:uri) { url.dup.concat "/#{id}" }
      let(:cache_key_prefix) { "#{Faker::Name.first_name.downcase}:" }
      let(:cache_key) { "#{cache_key_prefix}#{id}" }
      let(:cache_expiration) { Faker::Number.digit }

      before do
        Grape::Endpoint.before_each do |endpoint|
          allow(endpoint).to receive(:cache_key_prefix).and_return(cache_key_prefix)
          allow(endpoint).to receive(:cache_expiration).and_return(cache_expiration)
        end
      end

      after do
        get uri

        Grape::Endpoint.before_each nil
      end

      it 'tries to delete the developer with the provided :id' do
        expect(Developer).to receive(:delete).with(id)

        delete uri
      end

      include_examples :api_with_basic_authentication

      context 'when it was deleted' do
        before do
          allow(Developer).to receive(:delete).with(id).and_return(1)

          delete uri
        end

        after do
          delete uri
        end

        it 'removes it from redis' do
          expect_any_instance_of(Providers::RedisProvider).to receive(:del).with(cache_key)
        end

        include_examples :successful_no_content_response
      end

      context 'when it was not deleted' do
        before do
          allow(Developer).to receive(:delete).with(id).and_return(0)

          delete uri
        end

        after do
          delete uri
        end

        it 'does not try to remove it from redis' do
          expect_any_instance_of(Providers::RedisProvider).not_to receive(:del).with(cache_key)
        end
      end
    end

    include_examples :api_endpoint_with_id_requirements, ::Helpers::HTTP::METHODS::DELETE
  end

  describe '.id_requirement' do
    let(:id_pattern) { /[0-9]*/ }

    it 'returns the matching regex applied to ids' do
      expect(Developers::API.id_requirement).to eq id_pattern
    end
  end

  describe '.per_page' do
    let(:per_page) { APP_CONFIG['helpers']['pagination_helper']['per_page'] }

    it 'returns the default per_page parameter' do
      expect(Developers::API.per_page). to eq per_page
    end
  end

  describe '.max_per_page' do
    let(:max_per_page) { APP_CONFIG['helpers']['pagination_helper']['max_per_page'] }

    it 'returns the default max_per_page parameter' do
      expect(Developers::API.max_per_page). to eq max_per_page
    end
  end
end
