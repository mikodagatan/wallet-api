require 'base64'
require 'openssl'
require 'json'

class JwtService
  class << self
    SECRET_KEY = ENV['JWT_SECRET_KEY'] || 'default_secret_key'

    def encode(payload, algorithm = 'HS256')
      payload[:exp] = 1.minute.from_now.to_i # Expiration time

      header = { typ: 'JWT', alg: algorithm }
      encoded_header = base64_url_encode(header.to_json)
      encoded_payload = base64_url_encode(payload.to_json)
      signature = generate_signature("#{encoded_header}.#{encoded_payload}", SECRET_KEY, algorithm)

      "#{encoded_header}.#{encoded_payload}.#{signature}"
    end

    def decode(token, algorithm = 'HS256')
      encoded_header, encoded_payload, signature = token.split('.')
      payload = JSON.parse(base64_url_decode(encoded_payload))

      payload if valid_signature?("#{encoded_header}.#{encoded_payload}", signature, SECRET_KEY, algorithm)
    end

    def base64_url_encode(data)
      Base64.strict_encode64(data).tr('+/', '-_').delete('=')
    end

    def base64_url_decode(data)
      padded_data = data + '=' * (4 - data.length % 4)
      Base64.strict_decode64(padded_data.tr('-_', '+/'))
    end

    def generate_signature(data, secret_key, algorithm)
      digest = OpenSSL::Digest.new(algorithm.gsub('HS', 'sha'))
      hmac = OpenSSL::HMAC.digest(digest, secret_key, data)
      base64_url_encode(hmac)
    end

    def valid_signature?(data, signature, secret_key, algorithm)
      expected_signature = generate_signature(data, secret_key, algorithm)
      secure_compare(expected_signature, signature)
    end

    def secure_compare(expected_signature, actual_signature)
      return false unless expected_signature.bytesize == actual_signature.bytesize

      expected_bytes = expected_signature.unpack("C#{expected_signature.bytesize}")
      res = 0

      actual_signature.each_byte { |byte| res |= byte ^ expected_bytes.shift }
      res.zero?
    end
  end
end
