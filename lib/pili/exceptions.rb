# coding: utf-8
module Pili
  class ResponseError < Exception

    attr_reader :response

    def initialize(message, response = nil)
      @response = response
      super(message)
    end

    def http_code
      @response.code if @response
    end

    def error_code
      @response.parsed_response["error"] if @response
    end

    def error_message
      @response.parsed_response["message"] if @response
    end

    def http_body
      @response.body if @response
    end
  end
end
