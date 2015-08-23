# coding: utf-8
module Pili
  class Stream

    attr_reader :credentials, :id, :created_at, :updated_at, :title, :hub, :profiles, :hosts
    attr_accessor :publish_key, :publish_security, :disabled


    def initialize(credentials, options = {})
      @credentials      = credentials
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
      API.get_stream_status(@credentials, @id)
    end


    def update(options = {})
      API.update_stream(@credentials, @id, self.to_h.merge!(options))
    end


    def enable
      API.update_stream(@credentials, @id, disabled: false)
    end


    def disable
      API.update_stream(@credentials, @id, disabled: true)
    end


    def delete
      API.delete_stream(@credentials, @id)
    end


    def segments(options = {})
      API.get_stream_segments(@credentials, @id, options)
    end


    def rtmp_publish_url
      rtmp_publish_host = @hosts["publish"]["rtmp"]

      if @publish_security == "static"
        return "rtmp://#{rtmp_publish_host}/#{@hub}/#{@title}?key=#{@publish_key}"
      else
        nonce = Time.now.to_i
        token = Credentials.sign(publish_key, "/#{@hub}/#{@title}?nonce=#{nonce}")
        return "rtmp://#{rtmp_publish_host}/#{@hub}/#{@title}?nonce=#{nonce}&token=#{token}"
      end
    end


    def rtmp_live_urls
      live_rtmp_host = @hosts["live"]["rtmp"]

      urls = { Config.origin => "rtmp://#{live_rtmp_host}/#{@hub}/#{@title}" }

      @profiles.each do |profile|
        urls[profile] = "rtmp://#{live_rtmp_host}/#{@hub}/#{@title}@#{profile}"
      end

      urls
    end


    def http_flv_live_urls
      live_http_host = @hosts["live"]["http"]

      urls = { Config.origin => "http://#{live_http_host}/#{@hub}/#{@title}.flv" }

      @profiles.each do |profile|
        urls[profile] = "http://#{live_http_host}/#{@hub}/#{@title}@#{profile}.flv"
      end

      urls
    end


    def hls_live_urls
      live_http_host = @hosts["live"]["http"]

      urls = { Config.origin => "http://#{live_http_host}/#{@hub}/#{@title}.m3u8" }

      @profiles.each do |profile|
        urls[profile] = "http://#{live_http_host}/#{@hub}/#{@title}@#{profile}.m3u8"
      end

      urls
    end


    def hls_playback_urls(start_second, end_second)
      playback_http_host = @hosts["playback"]["http"]

      urls = { Config.origin => "http://#{playback_http_host}/#{@hub}/#{@title}.m3u8?start=#{start_second}&end=#{end_second}" }

      @profiles.each do |profile|
        urls[profile] = "http://#{playback_http_host}/#{@hub}/#{@title}@#{profile}.m3u8?start=#{start_second}&end=#{end_second}"
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


    def snapshot(name, format, options = {})
      API.snapshot(@credentials, @id, name, format, options)
    end


    def save_as(name, format, start_time, end_time, notify_url = nil)
      API.save_stream_as(@credentials, @id, name, format, start_time, end_time, notify_url)
    end


    def to_h
      {
        credentials:      @credentials,
        id:               @id,
        title:            @title,
        hub:              @hub,
        profiles:         @profiles,
        publish_key:      @publish_key,
        publish_security: @publish_security,
        disabled:         @disabled,
        hosts:            @hosts,
        created_at:       @created_at,
        updated_at:       @updated_at
      }
    end

  end
end