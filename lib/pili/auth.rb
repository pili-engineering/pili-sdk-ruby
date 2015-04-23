# coding: utf-8
require 'openssl'
require 'base64'
require 'uri'

module Pili
  module Auth
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

      def generate_query_string(body)
        body = body.to_json if body.is_a?(Hash)
        return body
      end

      def generate_signature(options = {})
        url, body = options[:url], options[:body]
        uri = URI.parse(url)
        signature = uri.path
        query_string = uri.query
        signature += '?' + query_string if !query_string.nil? && !query_string.empty?
        signature += "\n"
        signature += generate_query_string(body) if body.is_a?(Hash)
        return signature
      end

    end
  end
end