if RACK_ENV == 'test'
  # uses the default logger from grape
  APP_CONFIG['LOGGER'] = Grape::API.logger
else
  # creates a new logger, so that requests are logged both to stdout and filepath
  filepath = ENV['APP_HOST_LOG_FILEPATH'] || APP_CONFIG['logger']['filepath']
  log_file = File.open(filepath, 'a')
  log_file.sync = true
  APP_CONFIG['LOGGER'] = Logger.new GrapeLogging::MultiIO.new(STDOUT, log_file)
end

# configures the logger instance
APP_CONFIG['LOGGER'].formatter = GrapeLogging::Formatters::Default.new
APP_CONFIG['LOGGER'].level = APP_CONFIG['logger']['level']['default']
