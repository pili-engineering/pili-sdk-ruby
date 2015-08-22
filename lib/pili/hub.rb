# coding: utf-8
module Pili
  class Hub

    attr_reader :credentials, :hub_name


    def initialize(access_key, secret_key, hub_name)
      @credentials = Credentials.new access_key, secret_key
      @hub_name   = hub_name
    end


    def create_stream(options = {})
      API.create_stream(@credentials, @hub_name, options)
    end


    def get_stream(stream_id)
      API.get_stream(@credentials, stream_id)
    end


    def list_streams(options = {})
      API.list_streams(@credentials, @hub_name, options)
    end

  end
end