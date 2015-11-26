source 'https://rubygems.org'
ruby '2.2.3'

gem 'grape'

# single envs
group :test do
  gem 'rack-test', require: 'rack/test'
  gem 'shoulda-matchers', '~> 3.0'
  gem 'rspec'
  gem 'factory_girl'
  gem 'faker'
  gem 'simplecov', require: false
end

group :development do
  gem 'rubocop', require: false
end

group :qa do
end

group :stagging do
end

group :production do
end

# multiple envs
group :development, :test do
  gem 'pry-byebug'
end
