module AuthHelper
  def credentials_valid?(username, password)
    APP_CONFIG['middlewares']['auth']['credentials'][username] && APP_CONFIG['middlewares']['auth']['credentials'][username] == password
  end
end
