# coding: utf-8
module Pili
  module Config
    class << self

      DEFAULT_OPTIONS = {
        :api_version        => "v1",
        :api_scheme         => "http",
        :api_host           => "pili.qiniuapi.com"

        # :rtmp_publish_host  => "pub.z1.glb.pili.qiniup.com",
        # :rtmp_play_host     => "live.z1.glb.pili.qiniucdn.com",
        # :hls_play_host      => "hls.z1.glb.pili.qiniuapi.com",

        # :access_key         => "",
        # :secret_key         => ""
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