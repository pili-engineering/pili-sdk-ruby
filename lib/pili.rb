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


    def create_stream(hub, options = {})
      url = Config.api_base_url + "/streams"

      body = {
        :hub              => hub,
        :title            => options[:title],
        :publishKey       => options[:publish_key],
        :publishSecurity  => options[:publish_security] == "static" ? "static" : "dynamic",
        :clientIp         => options[:client_ip]
      }

      body.delete_if { |k, v| v.nil? }

      response = HTTP.api_post(url, body)
      response.parsed_response
    end


    def get_stream(stream_id)
      url = Config.api_base_url + "/streams/" + stream_id
      response = HTTP.api_get(url)
      response.parsed_response
    end

  end

end
