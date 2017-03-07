# coding: utf-8

require "base64"

module Pili
  class StreamInfo
    attr_reader :hub, :key
    
    # 表示禁用结束的时间, 0 表示不禁用, -1 表示永久禁用.
    attr_reader :disabled_till

    # 流转码配置数组
    attr_reader :converts
  
    def initialize(hub, key, disabled_till, converts)
      @hub = hub
      @key = key
      @disabled_till = disabled_till
      @converts = converts
    end
    
    def disabled?
      @disabled_till == -1 || @disabled_till > Time.new.to_i
    end
    
    def to_s
      "#<#{self.class} #{@hub}/#{@key} disabled:#{disabled?} converts:#{@converts}>"
    end
    
    def to_json
      {:hub=>@hub, :key=>@key, :disabled=>disabled?, :converts=>@converts}.to_json
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
      StreamInfo.new @hub, @key, ret["disabledTill"], ret["converts"]
    end
    
    # 无限期禁用一个流.
    def disable
      disable_till(-1)
    end

    # 禁用一个流.
    # 参数：
    #     timestamp 解除禁用的时间戳
    def disable_till(timestamp)
      @client.rpc.call_with_json("POST", "#{@base_url}/disabled", {:disabledTill=>timestamp})
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
    # 参数：
    #     fname: 保存到存储空间的文件名，可选，不指定系统会随机生成
    #     start: 整数，可选，Unix 时间戳，要保存的直播的起始时间，不指定或 0 值表示从第一次直播开始
    #     end: 整数，可选，Unix 时间戳，要保存的直播的结束时间，不指定或 0 值表示当前时间
    #     format: 保存的文件格式，可选，默认为m3u8，如果指定其他格式，则保存动作为异步模式
    #     pipeline: 异步模式时，dora的私有队列，可选，不指定则使用公共队列
    #     notify: 异步模式时，保存成功回调通知地址，可选，不指定则不通知
    #     expireDays: 更改ts文件的过期时间，可选，默认为永久保存 -1表示不更改ts文件的生命周期，正值表示修改ts文件的生命周期为expireDays
    #
    # 返回：
    #     fname: 字符串，表示保存后在存储空间里的文件名。
    #     persistentID: 字符串，持久化异步处理任务ID，异步模式才会返回该字段，通常用不到该字段
    def saveas(opt = {})
      ret = @client.rpc.call_with_json("POST", "#{@base_url}/saveas", opt)
      [ret["fname"], ret["persistentID"]]
    end

    # 保存直播截图
    #
    # 参数：
    #     fname 保存到存储空间的文件名，可选，不指定系统会随机生成。
    #     time 整数，可选，Unix 时间戳，要保存截图的时间点，不指定则为当前时间。
    #     format 保存的文件格式，可选，默认为jpg。
    #
    # 返回：
    #     fname => <String> # 字符串，表示保存后在存储空间里的文件名。
    def snapshot(opt = {})
      ret = @client.rpc.call_with_json("POST", "#{@base_url}/snapshot", opt)
      ret["fname"]
    end

    # 修改流转码配置
    #
    # 参数：
    #     profiles 字符串数组，元素为转码的分辨率如：720p, 480p
    #
    def update_converts(profiles)
      ret = @client.rpc.call_with_json("POST", "#{@base_url}/converts", :converts => profiles)
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
