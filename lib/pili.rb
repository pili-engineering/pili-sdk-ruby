# coding: utf-8
require 'rest_client'
require "pili/version"

module Pili
  autoload :Auth,   'pili/auth'
  autoload :Config, 'pili/config'

  class << self

    def setup!(options = {})
      Config.init options
    end

    def hubs
      url = Config.api_base_url + "/hubs"
      encoded_sign = Auth.sign(Config.secret_key, Auth.generate_signature({:url => url}))
      headers = {
        :accept => :json,
        "Authorization" => "Qiniu #{Config.access_key}:#{encoded_sign}"
      }

      p [url, headers]

      response = RestClient.get(url, headers)
    end


    def streams(hub)
      url = Config.api_base_url + "/streams?hub=#{hub}"
      encoded_sign = Auth.sign(Config.secret_key, Auth.generate_signature({:url => url}))
      headers = {
        :accept => :json,
        "Authorization" => "Qiniu #{Config.access_key}:#{encoded_sign}"
      }
      response = RestClient.get(url, headers)
    end

  end

end
