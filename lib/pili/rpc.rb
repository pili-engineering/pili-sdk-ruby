# coding: utf-8
require 'httparty'

module Pili
  module RPC
    class << self

      def get(credentials, url)
        url = Config.api_base_url + url

        signature_options = {
          :url => url,
          :method => "GET"
        }

        encoded_sign = Credentials.sign(credentials.secret_key, Credentials.generate_signature(signature_options))

        headers = { "Authorization" => "Qiniu #{credentials.access_key}:#{encoded_sign}" }

        response = HTTParty.get(url, :headers => headers)

        if response.code == 200
          response.parsed_response
        else
          raise ResponseError.new("Pili API Request Error", response)
        end
      end


      def post(credentials, url, body)
        url = Config.api_base_url + url

        signature_options = {
          :url => url,
          :content_type => "application/json",
          :method => "POST",
          :body => body
        }

        encoded_sign = Credentials.sign(credentials.secret_key, Credentials.generate_signature(signature_options))

        headers = {
          "Authorization" => "Qiniu #{credentials.access_key}:#{encoded_sign}",
          "Content-Type"  => "application/json"
        }

        response = HTTParty.post(url, :headers => headers, :body => body.to_json)

        if response.code == 200
          response.parsed_response
        else
          raise ResponseError.new("Pili API Request Error", response)
        end
      end


      def delete(credentials, url)
        url = Config.api_base_url + url

        signature_options = {
          :url => url,
          :method => "DELETE"
        }

        encoded_sign = Credentials.sign(credentials.secret_key, Credentials.generate_signature(signature_options))

        headers = { "Authorization" => "Qiniu #{credentials.access_key}:#{encoded_sign}" }

        response = HTTParty.delete(url, :headers => headers)

        if response.code == 204
          response.parsed_response
        else
          raise ResponseError.new("Pili API Request Error", response)
        end
      end

    end
  end
end