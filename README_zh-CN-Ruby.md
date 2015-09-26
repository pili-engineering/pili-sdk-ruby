# PILI直播 Ruby服务端SDK 使用指南

## 功能列表

- 直播流的创建、获取和列举
    - [x] hub.createStream()  // 创建流
    - [x] hub.getStream()  // 获取流
    - [x] hub.listStreams()  // 列举流
- 直播流的其他功能
    - [x] stream.toJsonString()  // 流信息转为json
    - [x] stream.update()      // 更新流
    - [x] stream.disable()      // 禁用流
    - [x] stream.enable()    // 启用流
    - [x] stream.status()     // 获取流状态
    - [x] stream.rtmpPublishUrl()   // 生成推流地址
    - [x] stream.rtmpLiveUrls()    // 生成rtmp播放地址
    - [x] stream.hlsLiveUrls()   // 生成hls播放地址
    - [x] stream.httpFlvLiveUrls()   // 生成flv播放地址
    - [x] stream.segments()      // 获取流片段
    - [x] stream.hlsPlaybackUrls()  // 生成hls回看地址
    - [x] stream.saveAs()        // 流另存为文件
    - [x] stream.snapshot()      // 获取快照
    - [x] stream.delete()    // 删除流

## 目录

- [安装](#installation)
- [用法](#usage)
    - [配置](#configuration)
    - [Hub](#hub)
        - [实例化hub对象](#instantiate-a-pili-hub-object)
        - [创建流](#create-a-new-stream)
        - [获取流](#get-an-exist-stream)
        - [列举流](#list-streams)
    - [直播流](#stream)
        - [流信息转为json](#to-json-string)
        - [更新流](#update-a-stream)
        - [禁用流](#disable-a-stream)
        - [启用流](#enable-a-stream)
        - [获取流状态](#get-stream-status)
        - [生成推流地址](#generate-rtmp-publish-url)
        - [生成rtmp播放地址](#generate-rtmp-live-play-urls)
        - [生成hls播放地址](#generate-hls-play-urls)
        - [生成flv播放地址](#generate-http-flv-live-play-urls)
        - [获取流片段](#get-stream-segments)
        - [生成hls回看地址](#generate-hls-playback-urls)
        - [流另存为文件](#save-stream-as-a-file)
        - [获取快照](#snapshot-stream)
        - [删除流](#delete-a-stream)
- [History](#history)

<a id="installation"></a>
## 安装

添加如下这行到你applications的 Gemfile 文件中:

    gem 'pili'

然后执行:

    $ bundle

或者按照如下这样自行安装:

    $ gem install pili


<a id="usage"></a>
## 用法:

<a id="configuration"></a>
### 配置

```ruby
require 'pili'

ACCESS_KEY  = 'Qiniu_AccessKey'
SECRETE_KEY = 'Qiniu_SecretKey'

HUB_NAME    = 'Pili_Hub_Name' # 使用前必须需要先要获得HUB_NAME

# 如有需要可以更改API host
# 
# 默认为 pili.qiniuapi.com
# pili-lte.qiniuapi.com 为最近更新版本
# 
# conf.API_HOST = 'pili.qiniuapi.com' # 默认
```


## Hub

<a id="instantiate-a-pili-hub-object"></a>
### 实例化hub对象
```ruby
credentials = Pili::Credentials.new(ACCESS_KEY, SECRETE_KEY)
hub = Pili::Hub.new(credentials, HUB_NAME)
puts "Hub initialize =>\n#{hub.inspect}\n\n"
```


<a id="create-a-new-stream"></a>
### 创建流

```ruby
begin
  title            = nil # 选填，默认自动生成
  publish_key      = nil # 选填，默认自动生成
  publish_security = nil # 选填, 可以为 "dynamic" 或 "static", 默认为 "dynamic"

  # stream = hub.create_stream()
  # or
  stream = hub.create_stream(title: title, publish_key: publish_key, publish_security: publish_security)

  puts "Hub create_stream() =>\n#{stream.inspect}\n\n"
rescue Exception => e
  puts "Hub create_stream() failed. Caught exception:\n#{e.http_body}\n\n"
end

##<Pili::Stream:0x007fdf9413ab98
#  @credentials=#<Pili::Credentials:0x007fdf939392c8 @access_key="0QxleRjH-IGYystrYdeY5w6KdkSdJVa5SaBUbJkY", @secret_key="Vg3u2240H6JL78sfjsgLohGLjk_jO5e0cdief0g3">,
#  @id="z1.hub1.55d886b5e3ba571322003121",
#  @title="55d886b5e3ba571322003121",
#  @hub="hub1",
#  @publish_key="0e18061751841053",
#  @publish_security="dynamic",
#  @disabled=false,
#  @hosts={
#    "publish"=>{
#      "rtmp"=>"eksg7h.publish.z1.pili.qiniup.com"
#    },
#    "live"=>{
#      "http"=>"eksg7h.live1-http.z1.pili.qiniucdn.com",
#      "rtmp"=>"eksg7h.live1-rtmp.z1.pili.qiniucdn.com"
#    },
#    "playback"=>{
#      "http"=>"eksg7h.playback1.z1.pili.qiniucdn.com"
#    }
#  },
#  @created_at="2015-08-22T14:27:01.62Z",
#  @updated_at="2015-08-22T14:27:01.62Z"
#>
```


<a id="get-an-exist-stream"></a>
### 获取流

```ruby
begin
  stream = hub.get_stream(stream.id)
  puts "Hub get_stream() =>\n#{stream.inspect}\n\n"
rescue Exception => e
  puts "Hub get_stream() failed. Caught exception:\n#{e.http_body}\n\n"
end

##<Pili::Stream:0x007fdf6413ab67
#  @credentials=#<Pili::Credentials:0x007fdf939c2238 @access_key="0QxleRjH-IGYystrYdeY5w6KdkSdJVa5SaBUbJkY", @secret_key="Vg3u2240H6JL78sfjsgLohGLjk_jO5e0cdief0g3">,
#  @id="z1.hub1.55d886b5e3ba571322003121",
#  @title="55d886b5e3ba571322003121",
#  @hub="hub1",
#  @publish_key="0e18061751841053",
#  @publish_security="dynamic",
#  @disabled=false,
#  @hosts={
#    "publish"=>{
#      "rtmp"=>"eksg7h.publish.z1.pili.qiniup.com"
#    },
#    "live"=>{
#      "http"=>"eksg7h.live1-http.z1.pili.qiniucdn.com",
#      "rtmp"=>"eksg7h.live1-rtmp.z1.pili.qiniucdn.com"
#    },
#    "playback"=>{
#      "http"=>"eksg7h.playback1.z1.pili.qiniucdn.com"
#    }
#  },
#  @created_at="2015-08-22T14:27:01.62Z",
#  @updated_at="2015-08-22T14:27:01.62Z"
#>
```


<a id="list-streams"></a>
### 列举流

```ruby
begin
  marker = nil # 选填
  limit  = nil # 选填
  title  = nil # 选填
  streams = hub.list_streams(marker: marker, limit: limit, title: title)
  puts "Hub list_streams() =>\n#{streams.inspect}\n\n"
rescue Exception => e
  puts "Hub list_streams() failed. Caught exception:\n#{e.http_body}\n\n"
end

#[
#  #<Pili::Stream:0x007fdf94108f58>,
#  #<Pili::Stream:0x007fdf94108f30>,
#  #<Pili::Stream:0x007fdf94108f08>,
#  #<Pili::Stream:0x007fdf94108ee0>,
#  #<Pili::Stream:0x007fdf94108eb8>,
#  #<Pili::Stream:0x007fdf94108e90>,
#  #<Pili::Stream:0x007fdf94108e68>,
#  #<Pili::Stream:0x007fdf94108e40>,
#  #<Pili::Stream:0x007fdf94108e18>,
#  #<Pili::Stream:0x007fdf94108df0>
#]
```


<a id="stream"></a>
## 直播流
<a id="to-json-string"></a>
### 流信息转为json

```ruby
json_string = stream.to_json()
puts "Stream stream.to_json() =>\n#{json_string}\n\n"

#'{
#  "id":"z1.hub1.55d886b5e3ba571322003121",
#  "title":"55d886b5e3ba571322003121",
#  "hub":"hub1",
#  "publish_key":"0e18061751841053",
#  "publish_security":"dynamic",
#  "disabled":false,
#  "hosts":{
#    "publish":{
#      "rtmp":"eksg7h.publish.z1.pili.qiniup.com"
#    },
#    "live":{
#      "http":"eksg7h.live1-http.z1.pili.qiniucdn.com",
#      "rtmp":"eksg7h.live1-rtmp.z1.pili.qiniucdn.com"
#    },
#    "playback":{
#      "http":"eksg7h.playback1.z1.pili.qiniucdn.com"
#    }
#  },
#  "created_at":"2015-08-22T10:27:01.62-04:00",
#  "updated_at":"2015-08-22T10:27:01.62-04:00"
#}'
```

<a id="update-a-stream"></a>
### 更新流

```ruby
begin
  stream.publish_key      = "new_secret_words" # 选填
  stream.publish_security = "static"           # 选填, 可以为 "dynamic" 或 "static", 默认为 "dynamic"
  stream.disabled         = nil                # 选填, 可以为 true 或 false
  stream = stream.update()
  puts "Stream update() =>\n#{stream.inspect}\n\n"
rescue Exception => e
  puts "Stream update() failed. Caught exception:\n#{e.http_body}\n\n"
end

##<Pili::Stream:0x007fdf6413ab67
#  @credentials=#<Pili::Credentials:0x007fdf939c2238 @access_key="0QxleRjH-IGYystrYdeY5w6KdkSdJVa5SaBUbJkY", @secret_key="Vg3u2240H6JL78sfjsgLohGLjk_jO5e0cdief0g3">,
#  @id="z1.hub1.55d886b5e3ba571322003121",
#  @title="55d886b5e3ba571322003121",
#  @hub="hub1",
#  @publish_key="new_secret_words",
#  @publish_security="static",
#  @disabled=false,
#  @hosts={
#    "publish"=>{
#      "rtmp"=>"eksg7h.publish.z1.pili.qiniup.com"
#    },
#    "live"=>{
#      "http"=>"eksg7h.live1-http.z1.pili.qiniucdn.com",
#      "rtmp"=>"eksg7h.live1-rtmp.z1.pili.qiniucdn.com"
#    },
#    "playback"=>{
#      "http"=>"eksg7h.playback1.z1.pili.qiniucdn.com"
#    }
#  },
#  @created_at="2015-08-22T14:27:01.62Z",
#  @updated_at="2015-08-22T14:27:01.62Z"
#>
```

<a id="disable-a-stream"></a>
### 禁用流

```ruby
begin
  stream = stream.disable()
  puts "Stream disable() =>\n#{stream.inspect}\n\n"
rescue Exception => e
  puts "Stream disable() failed. Caught exception:\n#{e.http_body}\n\n"
end

##<Pili::Stream:0x007fdf6413ab67
#  @credentials=#<Pili::Credentials:0x007fdf939c2238 @access_key="0QxleRjH-IGYystrYdeY5w6KdkSdJVa5SaBUbJkY", @secret_key="Vg3u2240H6JL78sfjsgLohGLjk_jO5e0cdief0g3">,
#  @id="z1.hub_name.55d886b5e3ba571322003121",
#  @title="55d886b5e3ba571322003121",
#  @hub="hub1",
#  @publish_key="new_secret_words",
#  @publish_security="static",
#  @disabled=true,
#  @hosts={
#    "publish"=>{
#      "rtmp"=>"eksg7h.publish.z1.pili.qiniup.com"
#    },
#    "live"=>{
#      "http"=>"eksg7h.live1-http.z1.pili.qiniucdn.com",
#      "rtmp"=>"eksg7h.live1-rtmp.z1.pili.qiniucdn.com"
#    },
#    "playback"=>{
#      "http"=>"eksg7h.playback1.z1.pili.qiniucdn.com"
#    }
#  },
#  @created_at="2015-08-22T14:27:01.62Z",
#  @updated_at="2015-08-22T14:27:01.62Z"
#>
```


<a id="enable-a-stream"></a>
### 启用流

```ruby
begin
  stream = stream.enable()
  puts "Stream enable() =>\n#{stream.inspect}\n\n"
rescue Exception => e
  puts "Stream enable() failed. Caught exception:\n#{e.http_body}\n\n"
end

##<Pili::Stream:0x007fdf6413ab67
#  @credentials=#<Pili::Credentials:0x007fdf939c2238 @access_key="0QxleRjH-IGYystrYdeY5w6KdkSdJVa5SaBUbJkY", @secret_key="Vg3u2240H6JL78sfjsgLohGLjk_jO5e0cdief0g3">,
#  @id="z1.hub1.55d886b5e3ba571322003121",
#  @title="55d886b5e3ba571322003121",
#  @hub="hub1",
#  @publish_key="new_secret_words",
#  @publish_security="static",
#  @disabled=false,
#  @hosts={
#    "publish"=>{
#      "rtmp"=>"eksg7h.publish.z1.pili.qiniup.com"
#    },
#    "live"=>{
#      "http"=>"eksg7h.live1-http.z1.pili.qiniucdn.com",
#      "rtmp"=>"eksg7h.live1-rtmp.z1.pili.qiniucdn.com"
#    },
#    "playback"=>{
#      "http"=>"eksg7h.playback1.z1.pili.qiniucdn.com"
#    }
#  },
#  @created_at="2015-08-22T14:27:01.62Z",
#  @updated_at="2015-08-22T14:27:01.62Z"
#>
```


<a id="get-stream-status"></a>
### 获取流状态

```ruby
begin
  status_info = stream.status()
  puts "Stream status() =>\n#{status_info.inspect}\n\n"
rescue Exception => e
  puts "Stream status() failed. Caught exception:\n#{e.http_body}\n\n"
end

#{
#  "addr"=>"222.73.202.226:2572",
#  "status"=>"connected",
#  "bytesPerSecond"=>16870.200000000001,
#  "framesPerSecond"=>{
#    "audio"=>42.200000000000003,
#    "video"=>14.733333333333333,
#    "data"=>0.066666666666666666
#  }
#}
```


<a id="generate-rtmp-publish-url"></a>
### 生成推流地址

```ruby
publish_url = stream.rtmp_publish_url()
puts "Stream rtmp_publish_url() =>\n#publish_url}\n\n"

# "rtmp://eksg7h.publish.z1.pili.qiniup.com/hub1/55d886b5e3ba571322003121?nonce=1440256178&token=ikRpJBxr4qkfRJkAz4dtiaWITAQ="
```


<a id="generate-rtmp-live-play-urls"></a>
### 生成rtmp播放地址

```ruby
urls = stream.rtmp_live_urls()
puts "Stream rtmp_live_urls() =>\n#{urls.inspect}\n\n"

# {
#   "ORIGIN"=>"rtmp://eksg7h.live1-rtmp.z1.pili.qiniucdn.com/hub_name/55d886b5e3ba571322003121"
# }
```


<a id="generate-hls-play-urls"></a>
### 生成hls播放地址

```ruby
urls = stream.hls_live_urls()
puts "Stream hls_live_urls() =>\n#{urls.inspect}\n\n"

# {
#   "ORIGIN"=>"http://eksg7h.live1-http.z1.pili.qiniucdn.com/hub1/55d886b5e3ba571322003121.m3u8"
# }
```


<a id="generate-http-flv-live-play-urls"></a>
### 生成flv播放地址

```ruby
urls = stream.http_flv_live_urls()
puts "Stream http_flv_live_urls() =>\n#{urls.inspect}\n\n"

# {
#   "ORIGIN"=>"http://eksg7h.live1-http.z1.pili.qiniucdn.com/hub1/55d886b5e3ba571322003121.flv"
# }
```


<a id="get-stream-segments"></a>
### 获取流片段

```ruby
begin
  start_time = nil  # 选填, integer, 单位为秒, 为UNIX时间戳
  end_time   = nil  # 选填, integer, 单位为秒, 为UNIX时间戳
  limit      = nil  # 选填, uint

  segments = stream.segments(start_time: start_time, end_time: end_time, limit: limit)

  puts "Stream segments() =>\n#{segments.inspect}\n\n"
rescue Exception => e
  puts "Stream segments() failed. Caught exception:\n#{e.http_body}\n\n"
end

# {
#   "segments":[
#     {
#       "start":1440256809,
#       "end":1440256842
#     },
#     {
#       "start":1440256842,
#       "end":1440256852
#     }
#   ]
# }
```


<a id="generate-hls-playback-urls"></a>
### 生成hls回看地址

```ruby
start_time = 1440196065 # 必填, integer, 单位为秒, 为UNIX时间戳
end_time   = 1440196105 # 必填, integer, 单位为秒, 为UNIX时间戳
urls = stream.hls_playback_urls(start_time, end_time)
puts "Stream hls_playback_urls() =>\n#{urls.inspect}\n\n"
# {
#   "ORIGIN"=>"http://eksg7h.playback1.z1.pili.qiniucdn.com/hub1/55d886b5e3ba571322003121.m3u8?start=1440196065&end=1440196105"
# }
```


<a id="save-stream-as-a-file"></a>
### 流另存为文件

```ruby
begin
  name       = "videoName.mp4" # 必填, string 类型
  format     = "mp4"           # 必填, string 类型
  start_time = 1440067100      # 必填, int64, 单位为秒, 为UNIX时间戳
  end_time   = 1440068104      # 必填, int64, 单位为秒, 为UNIX时间戳
  notify_url = nil             # 选填
  result = stream.save_as(name, format, start_time, end_time, notify_url)
  puts "Stream save_as() =>\n#{result.inspect}\n\n"
rescue Exception => e
  puts "Stream save_as() failed. Caught exception:\n#{e.http_body}\n\n"
end

# {
#   "url"=>"http://eksg7h.vod1.z1.pili.qiniucdn.com/recordings/z1.hub1.55d886b5e3ba571322003121/videoName.m3u8",
#   "targetUrl"=>"http://eksg7h.vod1.z1.pili.qiniucdn.com/recordings/z1.hub1.55d886b5e3ba571322003121/videoName.mp4",
#   "persistentId"=>"z1.55d894f77823de5a49b52a16"
# }
```

当使用 `saveAs()` 和 `snapshot()` 的时候, 由于是异步处理， 你可以在七牛的FOP接口上使用 `persistentId`来获取处理进度.参考如下：   
API: `curl -D GET http://api.qiniu.com/status/get/prefop?id={persistentId}`  
文档说明: <http://developer.qiniu.com/docs/v6/api/overview/fop/persistent-fop.html#pfop-status> 


<a id="snapshot-stream"></a>
### 获取快照

```ruby
begin
  name       = "imageName.jpg"  # 必填, string 类型
  format     = "jpg"            # 必填, string 类型
  options = {
    :time       => 1440067100,  # 选填, int64, 单位为秒, 为UNIX时间戳
    :notify_url => nil          # 选填
  }
  result = stream.snapshot(name, format, options)
  puts "Stream snapshot() =>\n#{result.inspect}\n\n"
rescue Exception => e
  puts "Stream snapshot() failed. Caught exception:\n#{e.http_body}\n\n"
end

# {
#   "targetUrl"=>"http://eksg7h.static1.z1.pili.qiniucdn.com/snapshots/z1.hub1.55d886b5e3ba571322003121/imageName.jpg",
#   "persistentId"=>"z1.55d8948f7823de5a49b52561"
# }
```


<a id="delete-a-stream"></a>
### 删除流

```ruby
begin
  result = stream.delete()
  puts "Stream delete() =>\n#{result.inspect}\n\n"
rescue Exception => e
  puts "Stream delete() failed. Caught exception:\n#{e.http_body}\n\n"
end

# nil
```


## History

- 1.5.0
  - Add stream.http_flv_live_urls()
  - Add stream.disable()
  - Add stream.enable()
  - Add stream.snapshot()
- 1.3.0
  - Add stream.saveas()
- 1.2.0
  - Add Client, Stream class
- 1.0.1
  - Add stream.status()
  - Update stream.update()
- 1.0.0
  - Update README create stream example code.
- 0.1.3
  - Update README create stream example code.
- 0.1.2
  - Fix stream list method parameter type.
- 0.1.0
  - Update README
  - Update get milliseconds method
- 0.0.1
  - Init SDK
  - Add Stream API
  - Add publish and play policy
