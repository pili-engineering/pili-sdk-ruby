# coding: utf-8
require 'httparty'

module Pili
  module API
    class << self

      def get(access_key, secret_key, url)
        signature_options = {
          :url => url,
          :method => "GET"
        }

        encoded_sign = Auth.sign(secret_key, Auth.generate_signature(signature_options))

        headers = { "Authorization" => "Qiniu #{access_key}:#{encoded_sign}" }

        response = HTTParty.get(url, :headers => headers)

        if response.code == 200
          response.parsed_response
        else
          raise ResponseError.new("Pili API Request Error", response)
        end
      end


      def post(access_key, secret_key, url, body)
        signature_options = {
          :url => url,
          :content_type => "application/json",
          :method => "POST",
          :body => body
        }

        encoded_sign = Auth.sign(secret_key, Auth.generate_signature(signature_options))

        headers = {
          "Authorization" => "Qiniu #{access_key}:#{encoded_sign}",
          "Content-Type"  => "application/json"
        }

        response = HTTParty.post(url, :headers => headers, :body => body.to_json)

        if response.code == 200
          response.parsed_response
        else
          raise ResponseError.new("Pili API Request Error", response)
        end
      end


      def delete(access_key, secret_key, url)
        signature_options = {
          :url => url,
          :method => "DELETE"
        }

        encoded_sign = Auth.sign(secret_key, Auth.generate_signature(signature_options))

        headers = { "Authorization" => "Qiniu #{access_key}:#{encoded_sign}" }

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