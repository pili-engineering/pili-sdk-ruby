# coding: utf-8
module Pili
  module Config
    class << self

      DEFAULT_OPTIONS = {
        :default_api_version        => "v1",
        :default_api_scheme         => "http",
        :default_api_host           => "pili.qiniuapi.com",

        :default_rtmp_publish_host  => "pub.z1.glb.pili.qiniup.com",
        :default_rtmp_play_host     => "live.z1.glb.pili.qiniucdn.com",
        :default_hls_play_host      => "hls.z1.glb.pili.qiniuapi.com",

        :access_key                 => "",
        :secret_key                 => ""
      }

      REQUIRED_OPTION_KEYS = [:access_key, :secret_key]

      attr_reader :settings, :default_params

      def init(options = {})
        @settings = DEFAULT_OPTIONS.merge!(options)
        REQUIRED_OPTION_KEYS.each do |opt|
          raise MissingArgsError, [opt] unless @settings.has_key?(opt)
        end
        @settings
      end

      def api_base_url
        "#{settings[:default_api_scheme]}://#{settings[:default_api_host]}/#{settings[:default_api_version]}"
      end

      def access_key
        settings[:access_key]
      end

      def secret_key
        settings[:secret_key]
      end

      def rtmp_PublishHost
        settings[:default_rtmp_publish_host]
      end

    end
  end
end