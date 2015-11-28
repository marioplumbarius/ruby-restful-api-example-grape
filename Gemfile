source 'https://rubygems.org'
ruby '2.2.3'

# gem 'unicorn'
gem 'sqlite3'
gem 'redis'
gem 'faker'
gem 'redis'

# frakework related libraries
gem 'grape'
gem 'grape-activerecord'
gem 'email_validator'
gem 'grape-entity'
gem 'grape-swagger'
gem 'grape-kaminari'

# single envs
group :test do
  gem 'rack-test', require: 'rack/test'
  gem 'shoulda-matchers', '~> 3.0'
  gem 'rspec'
  gem 'factory_girl'
  gem 'simplecov', require: false
end

group :development do
  gem 'rubocop', require: false
  gem 'standalone_migrations'
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
