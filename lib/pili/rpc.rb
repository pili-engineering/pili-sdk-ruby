require 'json'
require 'net/http'
require 'typhoeus'

module Pili
  class RPC
    def initialize(mac)
      @mac = mac
    end

    def new_request(method, url, params = {})
      req = Typhoeus::Request.new(url, method: method.downcase.to_sym, ssl_verifypeer: false, ssl_verifyhost: 0)
      if %w[POST PUT DELETE].include?(method.to_s.upcase)
        body = params.to_json
        req.options[:headers]['Content-Type'] = 'application/json'
        req.options[:headers]['Content-Length'] = body.length
        req.options[:body] = body
      else
        req.options[:params] = params
      end
      @mac.sign_request(req)
    end

    def call_with_json(method, url, params)
      req = new_request(method, url, params)
      resp = req.run
      if resp.code.to_s.start_with? '2'
        if resp.headers['Content-Type'] == 'application/json'
          JSON.parse resp.body
        else
          resp.body
        end
      else
        msg = "call #{url} failed: #{resp.code}"
        case resp.code.to_s
        when '612', '619'
          e = ResourceNotExist.new msg, resp
        when '614'
          e = ResourceConflict.new msg, resp
        else
          e = RPCError.new msg, resp
        end
        raise e
      end
    end
  end
end
