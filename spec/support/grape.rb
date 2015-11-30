RACK_ENV = 'test' unless defined?(RACK_ENV)
require File.expand_path('../../../config/boot.rb', __FILE__)

# necessary to load, among others methods, the controller ones, such as 'get', 'post', 'delete', etc
RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

def app
  @app ||= RESTFul::API
end
