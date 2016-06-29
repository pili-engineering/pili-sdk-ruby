# coding: utf-8
require 'digest/hmac'
require "base64"

module Pili
  class Mac

    attr_reader :access_key, :secret_key

    def initialize(access_key, secret_key)
      @access_key = access_key
      @secret_key = secret_key
    end

    def sign(data)
      signature = Base64.urlsafe_encode64(Digest::HMAC.digest(data, @secret_key, Digest::SHA1))
      "#{@access_key}:#{signature}"
    end
    
    def inc_body(req, content_type)
      type_ok = content_type != nil && content_type != "application/octet-stream"
      length_ok = req.content_length != nil && req.content_length > 0 && req.content_length < 1024*1024
      req.body != nil && type_ok && length_ok
    end
 
    def sign_request(req)
      data = "#{req.method} #{req.path}"
      
      # FIXME: how to deal with port, because default uri.port is 80
      data += "\nHost: #{req.uri.host}"
      
      content_type = req["Content-Type"]
      if content_type != nil
        data += "\nContent-Type: #{content_type}"
      end
      
      data += "\n\n"
      
      if inc_body(req, content_type)
        data += "#{req.body}"
      end
      
      sign(data)
    end
    
    private :inc_body
  end
end
