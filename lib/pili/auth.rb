require 'openssl'
require 'base64'

module Pili
  class Mac
    attr_reader :access_key, :secret_key

    def initialize(access_key, secret_key)
      @access_key = access_key
      @secret_key = secret_key
    end

    def sign(data)
      digest = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha1'), @secret_key, data)
      signature = Base64.urlsafe_encode64(digest)
      "#{@access_key}:#{signature}"
    end

    def inc_body(req, content_type)
      type_ok = !content_type.nil? && content_type != 'application/octet-stream'
      length_ok = !req.encoded_body.nil? && req.encoded_body.size.positive? && req.encoded_body.size < 1024 * 1024
      !req.encoded_body.nil? && type_ok && length_ok
    end

    def sign_request(req)
      default_headers = {
        'User-Agent': Config.user_agent
      }
      req.options[:headers].merge! default_headers
      uri = URI(req.url)
      method = req.options[:method].to_s.upcase
      data = "#{method} #{uri.path}"

      data += "?#{uri.query}" if uri.query

      data += "\nHost: #{uri.host}"

      content_type = req.options.dig(:headers, 'Content-Type')
      data += "\nContent-Type: #{content_type}" unless content_type.nil?

      data += "\n\n"

      data += req.options[:body].to_s if inc_body(req, content_type)

      authorization = sign(data)
      authorization = "Qiniu #{authorization}" if uri.host.include?('pili-pub')
      req.options[:headers][:Authorization] = authorization
      req
    end
  end
end
