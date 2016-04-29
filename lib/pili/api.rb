# coding: utf-8
require 'httparty'

module Pili
  module API
    class << self

      def create_stream(credentials, hub_name, options = {})
        url = "/streams"

        body = {
          :hub              => hub_name,
          :title            => options[:title],
          :publishKey       => options[:publish_key],
          :publishSecurity  => options[:publish_security] == "static" ? "static" : "dynamic",
          :clientIp         => options[:client_ip]
        }

        body.delete_if { |k, v| v.nil? }

        Stream.new credentials, RPC.post(credentials, url, body)
      end


      def get_stream(credentials, stream_id)
        url = "/streams/" + stream_id
        Stream.new credentials, RPC.get(credentials, url)
      end


      def list_streams(credentials, hub_name, options = {})
        url = "/streams?hub=#{hub_name}"

        url += "&status=#{options[:status]}" if options[:status] == "connected"
        url += "&marker=#{options[:marker]}" unless Utils.blank?(options[:marker])
        url += "&limit=#{options[:limit]}"   if options[:limit].is_a?(Fixnum)
        url += "&title=#{options[:title]}"   unless Utils.blank?(options[:title])

        streams = []

        items = RPC.get(credentials, url)["items"]
        items && items.each do |item|
          streams << Stream.new(credentials, item)
        end

        streams
      end


      def get_stream_status(credentials, stream_id)
        url = "/streams/#{stream_id}/status"
        RPC.get(credentials, url)
      end


      def update_stream(credentials, stream_id, options = {})
        url = "/streams/" + stream_id

        body = {}
        body[:publishKey]      = options[:publish_key]
        body[:publishSecurity] = options[:publish_security]
        body[:disabled]        = options[:disabled]

        body.delete_if { |k, v| v.nil? }

        Stream.new credentials, RPC.post(credentials, url, body)
      end


      def delete_stream(credentials, stream_id)
        url = "/streams/" + stream_id
        RPC.delete(credentials, url)
      end


      def get_stream_segments(credentials, stream_id, options = {})
        url = "/streams/#{stream_id}/segments"

        url += "?start=#{options[:start]}" if options[:start].is_a?(Fixnum)
        url += "&end=#{options[:end]}"     if options[:end].is_a?(Fixnum)
        url += "&limit=#{options[:limit]}" if options[:limit].is_a?(Fixnum)

        response = RPC.get(credentials, url)
        response["segments"] || []
      end


      def save_stream_as(credentials, stream_id, name, format, start_time, end_time, notify_url = nil, pipeline = nil)
        url = "/streams/" + stream_id + "/saveas"

        body = {}
        body[:name]      = name
        body[:format]    = format
        body[:start]     = start_time
        body[:end]       = end_time
        body[:notifyUrl] = notify_url
        body[:pipeline]  = pipeline

        body.delete_if { |k, v| v.nil? }

        RPC.post(credentials, url, body)
      end


      def snapshot(credentials, stream_id, name, format, options = {})
        url = "/streams/" + stream_id + '/snapshot'

        body = {}
        body[:name]      = name
        body[:format]    = format
        body[:time]      = options[:time]
        body[:notifyUrl] = options[:notify_url]

        body.delete_if { |k, v| v.nil? }

        RPC.post(credentials, url, body)
      end


    end
  end
end
