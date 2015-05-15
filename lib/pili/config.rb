# coding: utf-8
module Pili
  module Config
    class << self

      DEFAULT_OPTIONS = {
        :api_version        => "v1",
        :api_scheme         => "http",
        :api_host           => "pili.qiniuapi.com"
      }

      REQUIRED_OPTION_KEYS = [:access_key, :secret_key]

      attr_reader :settings

      def init(options = {})
        @settings = DEFAULT_OPTIONS.merge!(options)
        REQUIRED_OPTION_KEYS.each do |opt|
          raise("You did not provide both required args. Please provide the #{opt}.") unless @settings.has_key?(opt)
        end
        @settings
      end

      def api_base_url
        "#{settings[:api_scheme]}://#{settings[:api_host]}/#{settings[:api_version]}"
      end

      def access_key
        settings[:access_key]
      end

      def secret_key
        settings[:secret_key]
      end

    end
  end
end