# coding: utf-8
module Pili
  module Config
    class << self

      @@settings = {
        :api_scheme  => "http",
        :api_host    => "pili.qiniuapi.com",
        :api_version => "v2",
        :api_user_agent => "pili-sdk-ruby/v2-#{Pili::VERSION} Ruby/#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"
      }

      def init(options = {})
        @@settings.merge!(options)
      end
      
      def api_base_url
        "#{@@settings[:api_scheme]}://#{@@settings[:api_host]}/#{@@settings[:api_version]}"
      end
      
      def user_agent
        @@settings[:api_user_agent]
      end
      
    end
  end
end