# Pili Streaming Cloud server-side library for Ruby

## Features

- URL
	- [x] RTMP推流地址: rtmp_publish_url(domain, hub, stream_title, mac, expire_after_seconds)
	- [x] RTMP直播地址: rtmp_play_url(domain, hub, stream_title)
	- [x] HLS直播地址: hls_play_url(domain, hub, stream_title)
	- [x] HDL直播地址: hdl_play_url(domain, hub, stream_title)
	- [x] 直播封面地址: snapshot_play_url(domain, hub, stream_title)
- Hub
	- [x] 创建流: hub.create(stream_title)
	- [x] 获得流: hub.stream(stream_title)
	- [x] 列出流: hub.list(...)
	- [x] 列出正在直播的流: hub.list_live(...)
	- [x] 批量查询直播信息: hub.batch_query_live_status(stream_titles)
- Stream
	- [x] 流信息: stream.info()
	- [x] 无限期禁用流: stream.disable()
	- [x] 禁用流: stream.disable_till(timestamp)
	- [x] 启用流: stream.enable()
 	- [x] 查询直播状态: stream.live_status()
	- [x] 保存直播回放: stream.saveas(...)
	- [x] 保存直播截图: stream.snapshot(...)
	- [x] 更改流的实时转码规格: stream.update_converts(profiles)
	- [x] 查询直播历史: stream.history_activity(...)

## Contents

- [Installation](#installation)
- [Usage](#usage)
    - [Configuration](#configuration)
	- [URL](#url)
		- [Generate RTMP publish URL](#generate-rtmp-publish-url)
		- [Generate RTMP play URL](#generate-rtmp-play-url)
		- [Generate HLS play URL](#generate-hls-play-url)
		- [Generate HDL play URL](#generate-hdl-play-url)
		- [Generate Snapshot play URL](#generate-snapshot-play-url)
	- [Hub](#hub)
		- [Instantiate a Pili Hub object](#instantiate-a-pili-hub-object)
		- [Create a new Stream](#create-a-new-stream)
		- [Get a Stream](#get-a-stream)
		- [List Streams](#list-streams)
		- [List live Streams](#list-live-streams)
		- [Batch query live status](#batch-query-live-status)
	- [Stream](#stream)
		- [Get Stream info](#get-stream-info)
		- [Disable a Stream](#disable-a-stream)
		- [Disable a Stream with timestamp](#disable-a-stream-with-timestamp)
		- [Enable a Stream](#enable-a-stream)
		- [Get Stream live status](#get-stream-live-status)
		- [Save Stream live playback](#save-stream-live-playback)
		- [Save Stream snapshot](#save-stream-snapshot)
		- [Update converts](#update-converts)
		- [Get Stream history activity](#get-stream-history-activity)

## Installation

Add this line to your application's Gemfile:

    gem 'piliv2'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install piliv2


## Usage

### Configuration

```ruby
require "pili"

access_key = "<QINIU ACCESS KEY>" # 替换成自己 Qiniu 账号的 AccessKey.
secret_key = "<QINIU SECRET KEY>" # 替换成自己 Qiniu 账号的 SecretKey.
hub_name   = "<PILI HUB NAME>"    # Hub 必须事先存在.

mac = Pili::Mac.new(access_key, secret_key)
client = Pili::Client.new(mac)
hub = client.hub(hub_name)
```

### URL

#### Generate RTMP publish URL

```ruby
url = Pili.rtmp_publish_url("publish-rtmp.test.com", "PiliSDKTest", "streamtitle", mac, 60)
puts(url)
# rtmp://publish-rtmp.test.com/PiliSDKTest/streamtitle?e=1463023142&token=7O7hf7Ld1RrC_fpZdFvU8aCgOPuhw2K4eapYOdII:-5IVlpFNNGJHwv-2qKwVIakC0ME=
```

#### Generate RTMP play URL

```ruby
url = Pili.rtmp_play_url("live-rtmp.test.com", "PiliSDKTest", "streamtitle")
puts(url)
# rtmp://live-rtmp.test.com/PiliSDKTest/streamtitle
```

#### Generate HLS play URL

```ruby
url = Pili.hls_play_url("live-hls.test.com", "PiliSDKTest", "streamtitle")
puts(url)
# http://live-hls.test.com/PiliSDKTest/streamtitle.m3u8
```

#### Generate HDL play URL

```ruby
url = Pili.hdl_play_url("live-hdl.test.com", "PiliSDKTest", "streamtitle")
puts(url)
# http://live-hdl.test.com/PiliSDKTest/streamtitle.flv
```

#### Generate Snapshot play URL

```ruby
url = Pili.snapshot_play_url("live-snapshot.test.com", "PiliSDKTest", "streamtitle")
puts(url)
# http://live-snapshot.test.com/PiliSDKTest/streamtitle.jpg
```

### Hub

#### Instantiate a Pili Hub object

```ruby
mac = Pili::Mac.new(access_key, secret_key)
client = Pili::Client.new(mac)
hub = client.hub("PiliSDKTest")
```

#### Create a new Stream

```ruby
stream = hub.create("streamtitle")
puts(stream.info.to_json)
# {"hub":"PiliSDKTest","key":"streamtitle","disabled":false}
```

#### Get a Stream

```ruby
stream = hub.stream("streamtitle")
puts(stream.info.to_json)
# {"hub":"PiliSDKTest","key":"streamtitle","disabled":false}
```

#### List Streams

```ruby
titles, marker = hub.list(:prefix=>"str", :limit=>10)
puts titles.to_s, marker
# [<titles...>], <marker>
```

#### List live Streams

```ruby
titles, marker = hub.list_live(:prefix=>"str", :limit=>10)
puts titles.to_s, marker
# [<titles...>], <marker>
```

#### Batch query live status

```ruby
live_statuses = hub.batch_query_live_status(["stream1", "stream2"])
puts live_statuses
# {"startAt"=>1488798455, "clientIP"=>"119.130.107.231:35018", "bps"=>921960, "fps"=>{"audio"=>44, "video"=>29, "data"=>0}, "key"=>"stream1"}
# {"startAt"=>1488798287, "clientIP"=>"119.130.107.231:55924", "bps"=>867328, "fps"=>{"audio"=>42, "video"=>9, "data"=>0}, "key"=>"stream2"}
```

### Stream

#### Get Stream info

```ruby
stream = hub.stream(title)
puts(stream.info.to_json)
# {"hub": "PiliSDKTest", "key": "streamtitle", "disabled": false}
```

#### Disable a Stream

```ruby
stream = hub.stream("streamtitle")
puts("before disable: #{stream.info.to_json}")

stream.disable()

stream = hub.stream("streamtitle")
puts("after disable: #{stream.info.to_json}")
# before disable: {"hub":"PiliSDKTest","key":"streamtitle","disabled":false}
# after disable: {"hub":"PiliSDKTest","key":"streamtitle","disabled":true}
```

#### Disable a Stream with timestamp

```ruby
stream = hub.stream("streamtitle")
puts("before disable: #{stream.info.to_json}")

stream.disable_till(Time.now.to_i + 10)

puts("after disable: #{stream.info.to_json}")

sleep(10)

puts("after 10 seconds: #{stream.info.to_json}")

# before disable: {"hub":"PiliSDKTest","key":"streamtitle","disabled":false}
# after disable: {"hub":"PiliSDKTest","key":"streamtitle","disabled":true}
# before 10 seconds: {"hub":"PiliSDKTest","key":"streamtitle","disabled":false}
```

#### Enable a Stream

```ruby
stream = hub.stream("streamtitle")
puts("before enable: #{stream.info.to_json}")

stream.enable()

stream = hub.get("streamtitle")
puts("after enable: #{stream.info.to_json}")
# before disable: {"hub":"PiliSDKTest","key":"streamtitle","disabled":true}
# after disable: {"hub":"PiliSDKTest","key":"streamtitle","disabled":false}
```

#### Get Stream live status

```ruby
status = stream.live_status()
puts(status.to_json)
# {"startAt":1463022236,"clientIP":"222.73.202.226","bps":248,"fps":{"audio":45,"vedio":28,"data":0}}
```

#### Save Stream live playback

```ruby
fname, persistentID = stream.saveas(:format => "mp4")
puts(fname, persistentID)
# recordings/z1.PiliSDKTest.streamtitle/1463156847_1463157463.mp4
# z1.58bd753a8a3c0c3794a1d6ff
```
#### Save Stream snapshot
```ruby
fname = stream.snapshot()
puts(fname)
# stream-title-4532162526321415963.jpg
```

#### Update converts

```ruby
stream = hub.stream("streamtitle")
puts stream.info.to_json
stream.update_converts(["720p", "480p"])
puts stream.info.to_json
# {"hub":"PiliSDKTest","key":"streamtitle","disabled":false,"converts":[]}
# {"hub":"PiliSDKTest","key":"streamtitle","disabled":false,"converts":["720p","480p"]}
```

#### Get Stream history activity 

```ruby
activity = stream.history_activity()
puts(activity.to_json)
# [{"start":1463022236,"end":1463022518}]
```