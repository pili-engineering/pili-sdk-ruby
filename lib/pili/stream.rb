# coding: utf-8

require "base64"

module Pili
  class StreamInfo
    attr_reader :hub, :key
    
    # 表示禁用结束的时间, 0 表示不禁用, -1 表示永久禁用.
    attr_reader :disabled_till
  
    def initialize(hub, key, disabled_till)
      @hub = hub
      @key = key
      @disabled_till = disabled_till
    end
    
    def disabled?
      @disabled_till == -1 || @disabled_till > Time.new.to_i
    end
    
    def to_s
      "#<#{self.class} #{@hub}/#{@key} disabled:#{disabled?}>"
    end
    
    def to_json
      {:hub=>@hub, :key=>@key, :disabled=>disabled?}.to_json
    end
  end

  class Stream
    attr_reader :hub, :key
    
    def initialize(hub, key, client)
      @hub = hub
      @key = key
      
      ekey = Base64.urlsafe_encode64(key)
      @base_url = "#{Config.api_base_url}/hubs/#{hub}/streams/#{ekey}"
      
      @client = client
    end
    
    # Info 获得流信息.
    def info
      ret = @client.rpc.call_with_json("GET", @base_url, nil)
      StreamInfo.new @hub, @key, ret["disabledTill"]
    end
    
    # 禁用一个流.
    def disable
      @client.rpc.call_with_json("POST", "#{@base_url}/disabled", {:disabledTill=>-1})
    end
    
    # 启用一个流.
    def enable
      @client.rpc.call_with_json("POST", "#{@base_url}/disabled", {:disabledTill=>0})
    end
    
    # 查询直播状态.
    #
    # 返回
    #
    #   {
    #     "startAt" => <Integer>, # 直播开始的 Unix 时间戳, 0 表示当前没在直播.
    #     "clientIp" => <String>, #  直播的客户端 IP.
    #     "bps" => <Integer>, # 直播的码率、帧率信息.
    #     "fps" => {
    #       "audio" => <Integer>,
    #       "video" => <Integer>,
    #       "data" => <Integer>
    #     }
    #   }
    def live_status
      @client.rpc.call_with_json("GET", "#{@base_url}/live", nil)
    end
    
    # 保存直播回放.
    # 
    # 参数: start, end 是 Unix 时间戳, 限定了保存的直播的时间范围, 0 值表示不限定, 系统会默认保存最近一次直播的内容.
    # 
    # 返回保存的文件名, 由系统生成.
    def save(opt = {})
      ret = @client.rpc.call_with_json("POST", "#{@base_url}/saveas", opt)
      ret["fname"]
    end
    
    # 查询直播历史.
    #
    # 参数: start, end 是 Unix 时间戳, 限定了查询的时间范围, 0 值表示不限定, 系统会返回所有时间的直播历史.
    #
    # 返回:
    #
    #   {
    #     "start" => <Integer>,
    #     "end" => <Integer>
    #   }
    def history_activity(opt = {})
      url = "#{@base_url}/historyactivity"
      if !opt.empty?
        url += "?#{URI.encode_www_form opt}"
      end
      ret = @client.rpc.call_with_json("GET", url, nil)
      ret["items"]
    end
    
    def to_s
      "#<#{self.class} #{@hub}/#{@key}>"
    end
    
    def to_json
      {:hub=>@hub, :key=>@key}.to_json
    end
  end
end
