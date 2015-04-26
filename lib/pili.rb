# coding: utf-8
require 'json'
require 'httparty'
require "pili/version"

module Pili
  autoload :Auth,   'pili/auth'
  autoload :Config, 'pili/config'
  autoload :HTTP,   'pili/http'

  class << self

    def setup!(options = {})
      Config.init(options)
    end


    def stream_list(hub, options = {})
      url = Config.api_base_url + "/streams?hub=#{hub}"

      url += "&marker=#{options[:marker]}" if options[:marker].is_a?(Fixnum)
      url += "&limit=#{options[:limit]}"   if options[:limit].is_a?(Fixnum)

      response = HTTP.api_get(url)
      response.parsed_response
    end

  end

end
