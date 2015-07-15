# coding: utf-8
module Pili
  class Client

    attr_reader :access_key, :secret_key, :hub_name


    def initialize(access_key, secret_key, hub_name)
      @access_key = access_key
      @secret_key = secret_key
      @hub_name   = hub_name
    end


    def create_stream(options = {})
      url = Config.api_base_url + "/streams"

      body = {
        :hub              => @hub_name,
        :title            => options[:title],
        :publishKey       => options[:publish_key],
        :publishSecurity  => options[:publish_security] == "static" ? "static" : "dynamic",
        :clientIp         => options[:client_ip]
      }

      body.delete_if { |k, v| v.nil? }

      Stream.new self, API.post(@access_key, @secret_key, url, body)
    end


    def get_stream(stream_id)
      url = Config.api_base_url + "/streams/" + stream_id
      Stream.new self, API.get(@access_key, @secret_key, url)
    end


    def list_streams(options = {})
      url = Config.api_base_url + "/streams?hub=#{@hub_name}"

      url += "&marker=#{options[:marker]}" unless Utils.blank?(options[:marker])
      url += "&limit=#{options[:limit]}"   if options[:limit].is_a?(Fixnum)

      API.get(@access_key, @secret_key, url)
    end

  end
end