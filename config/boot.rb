# defines our constants
RACK_ENV = ENV['RACK_ENV'] ||= 'development' unless defined?(RACK_ENV)
APP_ROOT = File.expand_path('../..', __FILE__) unless defined?(APP_ROOT)

# loads our dependencies
require 'bundler/setup'
Bundler.require(:default, RACK_ENV)

# loads our configurarion
require 'yaml'
APP_CONFIG = YAML::load_file(File.join(__dir__, 'default.yml'))[RACK_ENV]

# loads all files needed from our app
dirs_to_load = APP_CONFIG["boot"]["scan"]["directories"]

dirs_to_load.each do |directory|
  expression = "#{APP_ROOT}/#{directory}/*.rb"
  Dir[expression].each do |file|
    require file
  end
end
