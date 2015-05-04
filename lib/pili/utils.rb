# coding: utf-8

module Pili
  module Utils
    class << self

      def blank?(arg)
        arg.to_s.strip.length == 0
      end

      def get_stream_hub_and_title(stream_id)
        a = stream_id.split(".")
        [a[1], a[2]]
      end

    end
  end
end