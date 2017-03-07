# coding: utf-8

module Pili
  class Client
    attr_reader :mac, :rpc
  
    def initialize(mac)
      @mac = mac
      @rpc = RPC.new mac
    end
    
    # hub 初始化一个 Hub.
    def hub(hub_name)
      Hub.new hub_name, self
    end
  end
  
  class << self
    # 生成 RTMP 推流地址.
    # +expire_after_seconds+ 表示 URL 在多久之后失效.
    def rtmp_publish_url(domain, hub, stream_title, mac, expire_after_seconds)
      expire = Time.new.to_i + expire_after_seconds
      path = "/#{hub}/#{stream_title}?e=#{expire}"
      token = mac.sign(path)
      "rtmp://#{domain}#{path}&token=#{token}"
    end
  
    # 生成 RTMP 直播地址.
    def rtmp_play_url(domain, hub, stream_title)
      "rtmp://#{domain}/#{hub}/#{stream_title}"
    end
    
    # 生成 HLS 直播地址.
    def hls_play_url(domain, hub, stream_title)
      "http://#{domain}/#{hub}/#{stream_title}.m3u8"
    end 
    
    # 生成 HDL 直播地址.
    def hdl_play_url(domain, hub, stream_title)
      "http://#{domain}/#{hub}/#{stream_title}.flv"
    end
    
    # 生成截图直播地址.
    def snapshot_play_url(domain, hub, stream_title)
      "http://#{domain}/#{hub}/#{stream_title}.jpg"
    end
  end
end