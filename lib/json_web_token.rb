class JsonWebToken
  SECRET_KEY = ENV["SECRET_KEY_BASE"] || Rails.application.secret_key_base

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded_array = JWT.decode(token, SECRET_KEY)

    payload = decoded_array[0]
    HashWithIndifferentAccess.new(payload)
  rescue JWT::DecodeError => e
    logger.error "JWT Decode Error: #{e.message}" if defined?(logger)
    nil
  end
end
