module Formatters
  class Error

    def self.format_validation_errors!(validation_errors)
      errors = {}
      validation_errors.errors.each do |key, value|
        error_key = key[0]

        errors[error_key] = value
      end

      errors
    end

  end

end
