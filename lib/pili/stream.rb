# coding: utf-8
module Pili
  class Stream

    LIVE_URL_ORIGIN_KEY = "ORIGIN"

    attr_reader :client
    attr_reader :id, :created_at, :updated_at, :title, :hub, :profiles, :hosts

    attr_accessor :publish_key, :publish_security, :disabled


    def initialize(client, options = {})
      @client           = client
      @id               = options["id"]
      @title            = options["title"]
      @hub              = options["hub"]
      @profiles         = options["profiles"] || []
      @publish_key      = options["publishKey"]
      @publish_security = options["publishSecurity"]
      @disabled         = options["disabled"]
      @hosts            = options["hosts"]

      @created_at       = options["createdAt"]
      @updated_at       = options["updatedAt"]
    end


    def status
      url = Config.api_base_url + "/streams/#{@id}/status"
      API.get(@client.access_key, @client.secret_key, url)
    end


    def update(options = {})
      url = Config.api_base_url + "/streams/" + @id

      body = {}
      body[:publishKey]      = options[:publish_key]
      body[:publishSecurity] = options[:publish_security] == "static" ? "static" : "dynamic"
      body[:disabled]        = options[:disabled]

      body.delete_if { |k, v| v.nil? }

      stream = API.post(@client.access_key, @client.secret_key, url, body)

      @publish_key      = stream["publishKey"]
      @publish_security = stream["publishSecurity"]
      @disabled         = stream["disabled"]
      @updated_at       = stream["updatedAt"]

      self
    end


    def delete
      url = Config.api_base_url + "/streams/" + @id
      API.delete(@client.access_key, @client.secret_key, url)
    end


    def segments(options = {})
      url = Config.api_base_url + "/streams/#{@id}/segments"

      url += "?start=#{options[:start]}" if options[:start].is_a?(Fixnum)
      url += "&end=#{options[:end]}"     if options[:end].is_a?(Fixnum)

      response = API.get(@client.access_key, @client.secret_key, url)
      response["segments"] || []
    end


    def rtmp_publish_url
      rtmp_publish_host = @hosts["publish"]["rtmp"]

      if @publish_security == "static"
        return "rtmp://#{rtmp_publish_host}/#{@hub}/#{@title}?key=#{@publish_key}"
      else
        nonce = (Time.now.to_f * 1000.0).to_i
        token = Auth.sign(publish_key, "/#{@hub}/#{@title}?nonce=#{nonce}")
        return "rtmp://#{rtmp_publish_host}/#{@hub}/#{@title}?nonce=#{nonce}&token=#{token}"
      end
    end


    def rtmp_live_urls
      rtmp_play_host = @hosts["play"]["rtmp"]

      urls = { LIVE_URL_ORIGIN_KEY => "rtmp://#{rtmp_play_host}/#{@hub}/#{@title}" }

      @profiles.each do |profile|
        urls[profile] = "rtmp://#{rtmp_play_host}/#{@hub}/#{@title}@#{profile}"
      end

      urls
    end


    def hls_live_urls
      hls_play_host = @hosts["play"]["hls"]

      urls = { LIVE_URL_ORIGIN_KEY => "http://#{hls_play_host}/#{@hub}/#{@title}.m3u8" }

      @profiles.each do |profile|
        urls[profile] = "http://#{hls_play_host}/#{@hub}/#{@title}@#{profile}.m3u8"
      end

      urls
    end


    def hls_playback_urls(start_second, end_second)
      hls_play_host = @hosts["play"]["hls"]

      urls = { LIVE_URL_ORIGIN_KEY => "http://#{hls_play_host}/#{@hub}/#{@title}.m3u8?start=#{start_second}&end=#{end_second}" }

      @profiles.each do |profile|
        urls[profile] = "http://#{hls_play_host}/#{@hub}/#{@title}@#{profile}.m3u8?start=#{start_second}&end=#{end_second}"
      end

      urls
    end


    def to_json
      {
        id: @id,
        title: @title,
        hub: @hub,
        profiles: @profiles,
        publish_key: @publish_key,
        publish_security: @publish_security,
        disabled: @disabled,
        hosts: @hosts,
        created_at: @created_at,
        updated_at: @updated_at
      }.to_json
    end


    def save_as(name, format, start_time, end_time, options = {})
      url = Config.api_base_url + "/streams/" + @id + "/saveas"

      body = {}
      body[:name]      = name
      body[:start]     = start_time
      body[:end]       = end_time
      body[:format]    = format
      body[:notifyUrl] = options[:notify_url]

      body.delete_if { |k, v| v.nil? }

      API.post(@client.access_key, @client.secret_key, url, body)
    end

  end
end