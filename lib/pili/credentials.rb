# coding: utf-8
require 'openssl'
require 'base64'
require 'uri'

module Pili
  class Credentials

    attr_reader :access_key, :secret_key


    def initialize(access_key, secret_key)
      @access_key = access_key
      @secret_key = secret_key
    end


    class << self

      def base64_url_encode(string)
        Base64.encode64(string).tr("+/", "-_").gsub(/[\n\r]?/, "")
      end

      def digest(secret, bytes)
        OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha1'), secret, bytes)
      end

      def sign(secret, bytes)
        base64_url_encode(digest(secret, bytes))
      end

      def generate_signature(options = {})
        method        = options[:method]
        url           = options[:url]
        content_type  = options[:content_type]
        body          = options[:body]

        uri = URI.parse(url)

        signature = "#{method} #{uri.path}"

        query_string = uri.query

        if !query_string.nil? && !query_string.empty?
          signature += '?' + query_string
        end

        signature += "\nHost: #{uri.host}"

        if !content_type.nil? && !content_type.empty? && content_type != "application/octet-stream"
          signature += "\nContent-Type: #{content_type}"
        end

        signature += "\n\n"

        if body.is_a?(Hash)
          signature += body.to_json
        end

        return signature
      end

    end
  end
end