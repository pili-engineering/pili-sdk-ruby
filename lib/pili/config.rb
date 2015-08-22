# coding: utf-8
module Pili
  module Config
    class << self

      @@settings = {
        :api_scheme  => "http",
        :api_host    => "pili.qiniuapi.com",
        :api_version => "v1"
      }

      def init(options = {})
        @@settings.merge!(options)
      end

      def api_base_url
        "#{@@settings[:api_scheme]}://#{@@settings[:api_host]}/#{@@settings[:api_version]}"
      end

    end
  end
end