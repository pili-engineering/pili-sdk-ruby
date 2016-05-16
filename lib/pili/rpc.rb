# coding: utf-8
require "json"
require "net/http"

module Pili
  class RPC
    def initialize(mac)
      @mac = mac
    end
    
    def new_request(method, url)
      case method
      when "POST"
        req = Net::HTTP::Post.new(URI(url))
      when "GET"
        req = Net::HTTP::Get.new(URI(url))
      else
        raise "unsupport RPC method #{method}"
      end
      req["User-Agent"] = Config.user_agent()
      req
    end
    
    def request(req)
      req["Authorization"] = "Qiniu #{@mac.sign_request req}"
      Net::HTTP.start(req.uri.host, req.uri.port) {|http| http.request req}
    end
    
    def call_with_json(method, url, params)
      req = new_request(method, url)
      
      if method == "POST" && params != nil
        req.body = params.to_json
        req["Content-Type"] = "application/json"
        req["Content-Length"] = req.body.length
      end
      resp = request(req)
      if resp.code.start_with? "2"
        if resp["Content-Type"] == "application/json"
          JSON.load resp.body
        else
          resp.body
        end
      else
        msg = "call #{url} failed: #{resp.code}"
        case resp.code
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
  
  private_constant :RPC
end