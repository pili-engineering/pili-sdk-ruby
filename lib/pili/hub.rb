module Pili
  # Hub 表示一个 Hub, 一个 Hub 包含多个 Stream
  class Hub
    attr_reader :hub

    def initialize(hub, client)
      @hub = hub
      @client = client
      @base_url = "#{Config.api_base_url}/hubs/#{hub}"
    end

    # 创建一个流对象.
    # 使用一个合法 rtmp_publish_url 发起推流就会自动创建流对象.
    # 一般情况下不需要调用这个 API, 除非是想提前对这一个流做一些特殊配置.
    def create(stream_title)
      @client.rpc.call_with_json('POST', "#{@base_url}/streams", { key: stream_title })
      Stream.new(@hub, stream_title, @client)
    end

    # 初始化一个流对象.
    def stream(stream_title)
      Stream.new(@hub, stream_title, @client)
    end

    def plist(opt = {})
      opt[:liveonly] ||= false
      opt[:prefix] ||= ''
      opt[:limit] ||= 0
      opt[:marker] ||= ''

      ret = @client.rpc.call_with_json('GET', "#{@base_url}/streams?#{URI.encode_www_form opt}", nil)
      [ret['items'].map { |x| x['key'] }, ret['marker']]
    end
    private :plist

    # list 根据 prefix 遍历 Hub 的流列表.
    #
    # 参数:
    #
    # limit 限定了一次最多可以返回的流个数, 实际返回的流个数可能小于这个 limit 值.
    # marker 是上一次遍历得到的流标.
    # omarker 记录了此次遍历到的游标, 在下次请求时应该带上, 如果 omarker 为 "" 表示已经遍历完所有流.
    #
    # For example:
    #
    #   marker = ""
    #   while true
    #     titles, marker = hub.list(:marker=> marker)
    #     # do something with titles.
    #     if marker == ""
    #       break
    #     end
    #   end
    def list(opt = {})
      opt[:liveonly] = false
      plist(opt)
    end

    # list 根据 prefix 遍历 Hub 正在播放的流列表.
    #
    # 参数:
    #
    # limit 限定了一次最多可以返回的流个数, 实际返回的流个数可能小于这个 limit 值.
    # marker 是上一次遍历得到的流标.
    # omarker 记录了此次遍历到的游标, 在下次请求时应该带上, 如果 omarker 为 "" 表示已经遍历完所有流.
    #
    # For example:
    #
    #   marker = ""
    #   while true
    #     titles, marker = hub.list_live(:marker=> marker)
    #     # do something with titles.
    #     if marker == ""
    #       break
    #     end
    #   end
    def list_live(opt = {})
      opt[:liveonly] = true
      plist(opt)
    end

    # 批量查询直播实时信息
    #
    # 参数：
    #
    # stream_titles 字符串数组，其中元素是想要查询的流的标题。
    #
    # 返回：
    #
    #   {
    #     "key" => <String>, # 流标题
    #     "startAt" => <Integer>, # 直播开始的 Unix 时间戳, 0 表示当前没在直播.
    #     "clientIp" => <String>, # 直播的客户端 IP.
    #     "bps" => <Integer>, # 直播的码率、帧率信息.
    #     "fps" => {
    #       "audio" => <Integer>,
    #       "video" => <Integer>,
    #       "data" => <Integer>
    #     }
    #   }
    #
    # 注意：
    #
    # 查询的流不存在或不在直播不会出现在返回结果里。
    def batch_query_live_status(stream_titles)
      ret = @client.rpc.call_with_json('POST', "#{@base_url}/livestreams", { items: stream_titles })
      ret['items']
    end

    def to_s
      "#<#{self.class} #{@hub}>"
    end

    def to_json(*_args)
      { hub: @hub }.to_json
    end
  end
end
