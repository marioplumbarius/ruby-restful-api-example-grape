RSpec.configure do |config|
  # loads migrations
  config.before(:suite) do
    silence_stream STDOUT do
      load "#{APP_ROOT}/db/schema.rb"
    end
  end
end
