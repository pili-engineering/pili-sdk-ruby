module Pili
  # Pub
  class Pub
    def initialize(client)
      @client = client
      @base_url = Config.pub_base_url.to_s
    end

    # 参数名称	必填	说明
    # marker	否	字符串，定位标识。
    # limit	否	整型，请求数目，上限1000。
    # name	否	字符串，任务名称，前缀匹配。
    def tasks(name: nil, limit: nil, marker: nil)
      path = 'tasks'
      params = {}
      params[:name] = name if name
      params[:limit] = limit || 10 if limit
      params[:marker] = marker if marker
      ret = client.rpc.call_with_json('GET', "#{@base_url}/#{path}", params)
      ret['list'] || []
    end

    # name	是	字符串，任务名称 必须满足 1-20个数字或字母。
    # sourceUrls	是	对象数组，源地址，数组必须长度必须大于等于1，大于1的情况下为播单模式。
    # runType	是	字符串，任务类型, normal: 普通转推,seek: seek转推。
    # forwardUrls	是	对象数组，转推地址，数组必须长度必须大于等于1。
    # filter	否	对象，任务过了条件，用于过滤出符合条件的worker实例，执行任务。
    # deliverStartTime	否	整型，任务定时开始时间，单位：ms,必须要大于当前时间且小于设置定时关闭的时间。
    # deliverStopTime	否	整型，任务定时关闭时间，单位：ms,必须要大于当前时间且小于设置定时开始的时间。

    # body = {
    #   name: 'test01',
    #   sourceUrls: [
    #     {
    #       url: 'https://d2zihajmogu5jn.cloudfront.net/bipbop-advanced/bipbop_16x9_variant.m3u8',
    #       videoType: 0
    #     }
    #   ],
    #   runType: 'normal',
    #   forwardUrls: [
    #     {
    #       url: 'rtmp://acetube-rtmp.ca3test.com/staging/RTMP_98A07067284?auth_key=1628055253-0-0-5c98b3d9f032a1f92148fbb57ef95137'
    #     }
    #   ],
    #   filter: {},
    #   deliverStartTime: (Time.now.to_i + 2) * 1000,
    #   deliverStopTime: (Time.now.to_i + 180) * 1000
    # }

    # https://developer.qiniu.com/pili/7320/create-a-task
    # 创建任务
    def create(body = {})
      path = 'tasks'
      @client.rpc.call_with_json('POST', "#{@base_url}/#{path}", body)
    end

    # https://developer.qiniu.com/pili/7327/editing-tasks
    # 更新任务
    def update(id, body)
      path = "tasks/#{id}"
      @client.rpc.call_with_json('POST', "#{@base_url}/#{path}", body)
    end

    # https://developer.qiniu.com/pili/7328/task-details
    # 任务详情
    def details(id)
      path = "tasks/#{id}"
      @client.rpc.call_with_json('GET', "#{@base_url}/#{path}", nil)
    end

    # https://developer.qiniu.com/pili/7330/delete-the-task
    # 删除任务
    def delete(id)
      path = "tasks/#{id}"
      @client.rpc.call_with_json('DELETE', "#{@base_url}/#{path}", nil)
    end

    # https://developer.qiniu.com/pili/7331/start-task
    # 开始任务
    def start(id)
      path = "tasks/#{id}/start"
      @client.rpc.call_with_json('POST', "#{@base_url}/#{path}", nil)
    end

    # https://developer.qiniu.com/pili/7331/stop-task
    # 结束任务
    def stop(id)
      path = "tasks/#{id}/stop"
      @client.rpc.call_with_json('POST', "#{@base_url}/#{path}", nil)
    end

    # https://developer.qiniu.com/pili/7333/task-run-log
    # 任务运行日志
    def log(id)
      path = "tasks/#{id}/runinfo"
      @client.rpc.call_with_json('GET', "#{@base_url}/#{path}", nil)
    end

    # {
    #   "index":0,
    #   "seek":100
    # }
    # 参数名称	必填	说明
    # index	否	int, sourceUrls索引号。
    # seek	是	int, seek位置,相对时间,单位: s。

    # https://developer.qiniu.com/pili/7743/the-seek-interface
    # seek
    def seek(id, body)
      path = "tasks/#{id}/seek"
      @client.rpc.call_with_json('POST', "#{@base_url}/#{path}", body)
    end

    # 说明
    # marker	否	字符串，定位符。
    # limit	否	整型，限制数，上线1000。
    # name	否	字符串，任务名称，前缀匹配。
    # start	否	整型，开始时间。
    # end	否	整型, 结束时间。
    # https://developer.qiniu.com/pili/7334/task-history
    # 历史记录
    def history(params = {})
      path = 'history'
      @client.rpc.call_with_json('GET', "#{@base_url}/#{path}", params)
    end
  end
end
