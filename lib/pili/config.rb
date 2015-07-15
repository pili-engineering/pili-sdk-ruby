# coding: utf-8
module Pili
  module Config
    class << self

      API_SCHEME  = "http"
      API_HOST    = "pili.qiniuapi.com"
      API_VERSION = "v1"

      # def init(options = {})
      #   @settings = DEFAULT_OPTIONS.merge!(options)
      #   REQUIRED_OPTION_KEYS.each do |opt|
      #     raise("You did not provide both required args. Please provide the #{opt}.") unless @settings.has_key?(opt)
      #   end
      #   @settings
      # end

      def api_base_url
        "#{API_SCHEME}://#{API_HOST}/#{API_VERSION}"
      end

    end
  end
end