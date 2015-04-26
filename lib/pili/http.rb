# coding: utf-8
require 'httparty'

module Pili
  class HTTP

    include HTTParty
    format :json

    class << self

      def api_get(url)
        signature_options = {
          :url => url,
          :method => "GET"
        }

        encoded_sign = Auth.sign(Config.secret_key, Auth.generate_signature(signature_options))

        headers = { "Authorization" => "Qiniu #{Config.access_key}:#{encoded_sign}" }

        get(url, :headers => headers)
      end


      def api_post(url, body)
        signature_options = {
          :url => url,
          :content_type => "application/json",
          :method => "POST",
          :body => body
        }

        encoded_sign = Auth.sign(Config.secret_key, Auth.generate_signature(signature_options))

        headers = {
          "Authorization" => "Qiniu #{Config.access_key}:#{encoded_sign}",
          "Content-Type"  => "application/json"
        }

        post(url, :headers => headers, :body => body.to_json)
      end


      def api_delete(url)
        signature_options = {
          :url => url,
          :method => "DELETE"
        }

        encoded_sign = Auth.sign(Config.secret_key, Auth.generate_signature(signature_options))

        headers = { "Authorization" => "Qiniu #{Config.access_key}:#{encoded_sign}" }

        delete(url, :headers => headers)
      end


    end

  end
end