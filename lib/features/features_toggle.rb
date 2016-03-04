module Features
  module Toggle

    def enabled?(feature_name)
      APP_CONFIG['features'][feature_name].enabled
    end

  end
end
