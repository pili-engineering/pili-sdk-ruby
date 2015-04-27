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


    def update_stream(stream_id, options = {})
      url = Config.api_base_url + "/streams/" + stream_id

      body = {
        :publishKey       => options[:publish_key],
        :publishSecurity  => options[:publish_security] == "static" ? "static" : "dynamic",
      }

      body.delete_if { |k, v| v.nil? }

      response = HTTP.api_post(url, body)
      response.parsed_response
    end


    def delete_stream(stream_id)
      url = Config.api_base_url + "/streams/" + stream_id
      response = HTTP.api_delete(url)
      response.parsed_response
    end


    def get_stream_segments(stream_id, options = {})
      url = Config.api_base_url + "/streams/#{stream_id}/segments"

      url += "?start=#{options[:start]}" if options[:start].is_a?(Fixnum)
      url += "&end=#{options[:end]}"     if options[:end].is_a?(Fixnum)

      response = HTTP.api_get(url)
      response.parsed_response
    end


    def get_stream_publish_url(stream_id, publish_key, publish_security, nonce = Time.now.to_i)
      a = stream_id.split(".")
      hub, title = a[1], a[2]

      if publish_security == "static"
        "rtmp://#{Config.rtmp_publish_host}/#{hub}/#{title}?key=#{publish_key}"
      else
        token = Auth.sign(Config.secret_key, "/#{hub}/#{title}?nonce=#{nonce}")
        "rtmp://#{Config.rtmp_publish_host}/#{hub}/#{title}?nonce=#{nonce}&token=#{token}"
      end
    end


    def get_stream_rtmp_live_url(stream_id, preset = nil)
      a = stream_id.split(".")
      hub, title = a[1], a[2]

      if preset.nil? && preset.empty?
        return "rtmp://#{Config.rtmp_play_host}/#{hub}/#{title}"
      else
        return "rtmp://#{Config.rtmp_play_host}/#{hub}/#{title}@#{profile}"
      end

    end


    def get_stream_hls_live_url(stream_id, preset = nil)
      a = stream_id.split(".")
      hub, title = a[1], a[2]

      if preset.nil? && preset.empty?
        "http://#{Config.hls_play_host}/#{hub}/#{title}.m3u8"
      else
        "http://#{Config.hls_play_host}/#{hub}/#{title}@#{profile}.m3u8"
      end
    end


    def get_stream_hls_playback_url(stream_id, start_second, end_second, preset = nil)
      a = stream_id.split(".")
      hub, title = a[1], a[2]

      if preset.nil? && preset.empty?
        "http://#{Config.hls_play_host}/#{hub}/#{title}.m3u8?start=#{start_second}&end=#{end_second}"
      else
        "http://#{Config.hls_play_host}/#{hub}/#{title}@#{profile}.m3u8?start=#{start_second}&end=#{end_second}"
      end
    end


  end

end
