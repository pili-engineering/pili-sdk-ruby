# coding: utf-8
require 'httparty'

module Pili
  class HTTP

    include HTTParty
    format :json

    class << self

      def api_get(url)
        signature_options = { :url => url, :method => "GET" }

        encoded_sign = Auth.sign(Config.secret_key, Auth.generate_signature(signature_options))

        headers = { "Authorization" => "Qiniu a #{Config.access_key}:#{encoded_sign}" }

        get(url, :headers => headers)
      end

    end

  end
end