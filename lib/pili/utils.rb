# coding: utf-8

module Pili
  module Utils
    class << self

      def blank?(arg)
        arg.to_s.strip.length == 0
      end

    end
  end
end