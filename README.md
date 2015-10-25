# Pili Streaming Cloud server-side library for Ruby

## Features

- Stream Create,Get,List
  - [x] hub.create_stream()
  - [x] hub.get_stream()
  - [x] hub.list_streams()
- Stream operations else
  - [x] stream.to_json()
  - [x] stream.update()
  - [x] stream.disable()
  - [x] stream.enable()
  - [x] stream.status()
  - [x] stream.rtmp_publish_url()
  - [x] stream.rtmp_live_urls()
  - [x] stream.hls_live_urls()
  - [x] stream.http_flv_live_urls()
  - [x] stream.segments()
  - [x] stream.hls_playback_urls()
  - [x] stream.save_as()
  - [x] stream.snapshot()
  - [x] stream.delete()

## Contents

- [Installation](#installation)
- [Usage](#usage)
  - [Configuration](#configuration)
  - [Hub](#hub)
    - [Instantiate a Pili Hub object](#instantiate-a-pili-hub-object)
    - [Create a new Stream](#create-a-new-stream)
    - [Get a Stream](#get-a-stream)
    - [List Streams](#list-streams)
  - [Stream](#stream)
    - [To JSON String](#to-json-string)
    - [Update a Stream](#update-a-stream)
    - [Disable a Stream](#disable-a-stream)
    - [Enable a Stream](#enable-a-stream)
    - [Generate RTMP publish URL](#generate-rtmp-publish-url)
    - [Generate RTMP live play URLs](#generate-rtmp-live-play-urls)
    - [Generate HLS live play URLs](#generate-hls-live-play-urls)
    - [Generate HTTP-FLV live play URLs](#generate-http-flv-live-play-urls)
    - [Get Stream segments](#get-stream-segments)
    - [Generate HLS playback URLs](#generate-hls-playback-urls)
    - [Save Stream as a file](#save-stream-as-a-file)
    - [Snapshot Stream](#snapshot-stream)
    - [Delete a stream](#delete-a-stream)
- [History](#history)

## Installation

Add this line to your application's Gemfile:

    gem 'pili'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pili


## Usage

### Configuration

```ruby
require 'pili'

ACCESS_KEY  = 'Qiniu_AccessKey'
SECRETE_KEY = 'Qiniu_SecretKey'

HUB_NAME    = 'Pili_Hub_Name' # The Hub must be exists before use

# Change API host as necessary
# pili.qiniuapi.com as default
# pili-lte.qiniuapi.com is the latest RC version
# Pili::Config.init api_host: 'pili.qiniuapi.com' # default
```


## Hub

### Instantiate a Pili Hub object
```ruby
credentials = Pili::Credentials.new(ACCESS_KEY, SECRETE_KEY)
hub = Pili::Hub.new(credentials, HUB_NAME)
puts "Hub initialize =>\n#{hub.inspect}\n\n"
```


### Create a new Stream

```ruby
begin
  title            = nil # optional, auto-generated as default
  publish_key      = nil # optional, auto-generated as default
  publish_security = nil # optional, can be "dynamic" or "static", "dynamic" as default

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
#      "hdl"=>"eksg7h.live1-hdl.z1.pili.qiniucdn.com",
#      "hls"=>"eksg7h.live1-hls.z1.pili.qiniucdn.com",
#      "rtmp"=>"eksg7h.live1-rtmp.z1.pili.qiniucdn.com"
#    },
#    "playback"=>{
#      "hls"=>"eksg7h.playback1.z1.pili.qiniucdn.com"
#    }
#  },
#  @created_at="2015-08-22T14:27:01.62Z",
#  @updated_at="2015-08-22T14:27:01.62Z"
#>
```


### Get a Stream

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
#      "hdl"=>"eksg7h.live1-hdl.z1.pili.qiniucdn.com",
#      "hls"=>"eksg7h.live1-hls.z1.pili.qiniucdn.com",
#      "rtmp"=>"eksg7h.live1-rtmp.z1.pili.qiniucdn.com"
#    },
#    "playback"=>{
#      "hls"=>"eksg7h.playback1.z1.pili.qiniucdn.com"
#    }
#  },
#  @created_at="2015-08-22T14:27:01.62Z",
#  @updated_at="2015-08-22T14:27:01.62Z"
#>
```


### List Streams

```ruby
begin
  status = nil # optional, can be "connected"
  marker = nil # optional
  limit  = nil # optional
  title  = nil # optional
  streams = hub.list_streams(status: status, marker: marker, limit: limit, title: title)
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


## Stream

### To JSON String

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

### Update a Stream

```ruby
begin
  stream.publish_key      = "new_secret_words" # optional
  stream.publish_security = "static"           # optional, can be "dynamic" or "static", "dynamic" as default
  stream.disabled         = nil                # optional, can be true or false
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
#      "hdl"=>"eksg7h.live1-hdl.z1.pili.qiniucdn.com",
#      "hls"=>"eksg7h.live1-hls.z1.pili.qiniucdn.com",
#      "rtmp"=>"eksg7h.live1-rtmp.z1.pili.qiniucdn.com"
#    },
#    "playback"=>{
#      "hls"=>"eksg7h.playback1.z1.pili.qiniucdn.com"
#    }
#  },
#  @created_at="2015-08-22T14:27:01.62Z",
#  @updated_at="2015-08-22T14:27:01.62Z"
#>
```

### Disable a Stream

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
#      "hdl"=>"eksg7h.live1-hdl.z1.pili.qiniucdn.com",
#      "hls"=>"eksg7h.live1-hls.z1.pili.qiniucdn.com",
#      "rtmp"=>"eksg7h.live1-rtmp.z1.pili.qiniucdn.com"
#    },
#    "playback"=>{
#      "hls"=>"eksg7h.playback1.z1.pili.qiniucdn.com"
#    }
#  },
#  @created_at="2015-08-22T14:27:01.62Z",
#  @updated_at="2015-08-22T14:27:01.62Z"
#>
```


### Enable a Stream

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
#      "hdl"=>"eksg7h.live1-hdl.z1.pili.qiniucdn.com",
#      "hls"=>"eksg7h.live1-hls.z1.pili.qiniucdn.com",
#      "rtmp"=>"eksg7h.live1-rtmp.z1.pili.qiniucdn.com"
#    },
#    "playback"=>{
#      "hls"=>"eksg7h.playback1.z1.pili.qiniucdn.com"
#    }
#  },
#  @created_at="2015-08-22T14:27:01.62Z",
#  @updated_at="2015-08-22T14:27:01.62Z"
#>
```


# Get Stream status

```ruby
begin
  status_info = stream.status()
  puts "Stream status() =>\n#{status_info.inspect}\n\n"
rescue Exception => e
  puts "Stream status() failed. Caught exception:\n#{e.http_body}\n\n"
end

#{
#  "startFrom"=>"2015-09-10T05:58:10.289+08:00",
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


### Generate RTMP publish URL

```ruby
publish_url = stream.rtmp_publish_url()
puts "Stream rtmp_publish_url() =>\n#publish_url}\n\n"

# "rtmp://eksg7h.publish.z1.pili.qiniup.com/hub1/55d886b5e3ba571322003121?nonce=1440256178&token=ikRpJBxr4qkfRJkAz4dtiaWITAQ="
```


### Generate RTMP live play URLs

```ruby
urls = stream.rtmp_live_urls()
puts "Stream rtmp_live_urls() =>\n#{urls.inspect}\n\n"

# {
#   "ORIGIN"=>"rtmp://eksg7h.live1-rtmp.z1.pili.qiniucdn.com/hub_name/55d886b5e3ba571322003121"
# }
```


### Generate HLS live play URLs

```ruby
urls = stream.hls_live_urls()
puts "Stream hls_live_urls() =>\n#{urls.inspect}\n\n"

# {
#   "ORIGIN"=>"http://eksg7h.live1-hls.z1.pili.qiniucdn.com/hub1/55d886b5e3ba571322003121.m3u8"
# }
```


### Generate HTTP-FLV live play URLs

```ruby
urls = stream.http_flv_live_urls()
puts "Stream http_flv_live_urls() =>\n#{urls.inspect}\n\n"

# {
#   "ORIGIN"=>"http://eksg7h.live1-hdl.z1.pili.qiniucdn.com/hub1/55d886b5e3ba571322003121.flv"
# }
```


### Get Stream segments

```ruby
begin
  start_time = nil  # optional, integer, in second, unix timestamp
  end_time   = nil  # optional, integer, in second, unix timestamp
  limit      = nil  # optional, uint

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


### Generate HLS playback URLs

```ruby
start_time = 1440196065 # optional, integer, in second, unix timestamp
end_time   = 1440196105 # optional, integer, in second, unix timestamp
urls = stream.hls_playback_urls(start_time, end_time)
puts "Stream hls_playback_urls() =>\n#{urls.inspect}\n\n"
# {
#   "ORIGIN"=>"http://eksg7h.playback1.z1.pili.qiniucdn.com/hub1/55d886b5e3ba571322003121.m3u8?start=1440196065&end=1440196105"
# }
```


### Save Stream as a file

```ruby
begin
  name       = "videoName.mp4" # required, string
  format     = "mp4"           # required, string
  start_time = 1440067100      # required, int64, in second, unix timestamp
  end_time   = 1440068104      # required, int64, in second, unix timestamp
  notify_url = nil             # optional
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

While invoking `saveAs()` and `snapshot()`, you can get processing state via Qiniu FOP Service using `persistentId`.
API: `curl -D GET http://api.qiniu.com/status/get/prefop?id={PersistentId}`
Doc reference: <http://developer.qiniu.com/docs/v6/api/overview/fop/persistent-fop.html#pfop-status>


### Snapshot Stream

```ruby
begin
  name       = "imageName.jpg"  # required, string
  format     = "jpg"            # required, string
  options = {
    :time       => 1440067100,  # optional, int64, in second, unix timestamp
    :notify_url => nil          # optional
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


### Delete a Stream

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
