require 'simplecov'

SimpleCov.configure do
  minimum_coverage 100
  refuse_coverage_drop

  add_group 'APIs', ['app/apis', 'app/index.rb']
  add_group 'Entities', 'app/entities'
  add_group 'Formatters', 'app/formatters'
  add_group 'Helpers', 'app/helpers'
  add_group 'Middlewares', 'app/middlewares'
  add_group 'Models', 'app/models'
  add_group 'Providers', 'app/providers'
  add_group 'Config', 'config'

  add_filter '/spec/'
end

SimpleCov.start
