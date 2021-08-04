module Pili
  module Config
    class << self
      SETTINGS = {
        api_scheme: 'https',
        api_host: 'pili.qiniuapi.com',
        pub_base_url: 'pili-pub.qiniuapi.com',
        api_version: 'v2',
        api_user_agent: "AceCamp/v2-#{Pili::VERSION} Ruby/#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"
      }

      def init(options = {})
        SETTINGS.merge!(options)
      end

      def api_base_url
        "#{SETTINGS[:api_scheme]}://#{SETTINGS[:api_host]}/#{SETTINGS[:api_version]}"
      end

      def pub_base_url
        "#{SETTINGS[:api_scheme]}://#{SETTINGS[:pub_base_url]}"
      end

      def user_agent
        SETTINGS[:api_user_agent]
      end
    end
  end
end
