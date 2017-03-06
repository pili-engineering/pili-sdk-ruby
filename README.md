# Pili Streaming Cloud server-side library for Ruby

## Features

- URL
	- [x] RTMP推流地址: rtmp_publish_url(domain, hub, stream_key, mac, expire_after_seconds)
	- [x] RTMP直播地址: rtmp_play_url(domain, hub, stream_key)
	- [x] HLS直播地址: hls_play_url(domain, hub, stream_key)
	- [x] HDL直播地址: hdl_play_url(domain, hub, stream_key)
	- [x] 截图直播地址: snapshot_play_url(domain, hub, stream_key)
- Hub
	- [x] 创建流: hub.create(stream_key)
	- [x] 获得流: hub.stream(stream_key)
	- [x] 列出流: hub.list(...)
	- [x] 列出正在直播的流: hub.list_live(...)
	- [x] 批量查询直播信息: hub.batch_query_live_status(stream_titles)
- Stream
	- [x] 流信息: stream.info()
	- [x] 禁用流: stream.disable()
	- [x] 启用流: stream.enable()
 	- [x] 查询直播状态: stream.live_status()
	- [x] 保存直播回放: stream.save(...)
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
		- [Enable a Stream](#enable-a-stream)
		- [Get Stream live status](#get-stream-live-status)
		- [Get Stream history activity](#get-stream-history-activity)
		- [Save Stream live playback](#save-stream-live-playback)

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
require "piliv2"

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
url = Pili.rtmp_publish_url("publish-rtmp.test.com", "PiliSDKTest", "streamkey", mac, 60)
puts(url)
# rtmp://publish-rtmp.test.com/PiliSDKTest/streamkey?e=1463023142&token=7O7hf7Ld1RrC_fpZdFvU8aCgOPuhw2K4eapYOdII:-5IVlpFNNGJHwv-2qKwVIakC0ME=
```

#### Generate RTMP play URL

```ruby
url = Pili.rtmp_play_url("live-rtmp.test.com", "PiliSDKTest", "streamkey")
puts(url)
# rtmp://live-rtmp.test.com/PiliSDKTest/streamkey
```

#### Generate HLS play URL

```ruby
url = Pili.hls_play_url("live-hls.test.com", "PiliSDKTest", "streamkey")
puts(url)
# http://live-hls.test.com/PiliSDKTest/streamkey.m3u8
```

#### Generate HDL play URL

```ruby
url = Pili.hdl_play_url("live-hdl.test.com", "PiliSDKTest", "streamkey")
puts(url)
# http://live-hdl.test.com/PiliSDKTest/streamkey.flv
```

#### Generate Snapshot play URL

```ruby
url = Pili.snapshot_play_url("live-snapshot.test.com", "PiliSDKTest", "streamkey")
puts(url)
# http://live-snapshot.test.com/PiliSDKTest/streamkey.jpg
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
stream = hub.create("streamkey")
puts(stream.info.to_json)
# {"hub":"PiliSDKTest","key":"streamkey","disabled":false}
```

#### Get a Stream

```ruby
stream = hub.stream("streamkey")
puts(stream.info.to_json)
# {"hub":"PiliSDKTest","key":"streamkey","disabled":false}
```

#### List Streams

```ruby
keys, marker = hub.list(:prefix=>"str", :limit=>10)
puts keys.to_s, marker
# [<keys...>], <marker>
```

#### List live Streams

```ruby
keys, marker = hub.list_live(:prefix=>"str", :limit=>10)
puts keys.to_s, marker
# [<keys...>], <marker>
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
stream = hub.stream(key)
puts(stream.info.to_json)
# {"hub": "PiliSDKTest", "key": "streamkey", "disabled": false}
```

#### Disable a Stream

```ruby
stream = hub.stream("streamkey")
puts("before disable: #{stream.info.to_json}")

stream.disable()

stream = hub.stream("streamkey")
puts("after disable: #{stream.info.to_json}")
# before disable: {"hub":"PiliSDKTest","key":"streamkey","disabled":false}
# after disable: {"hub":"PiliSDKTest","key":"streamkey","disabled":true}
```

#### Enable a Stream

```ruby
stream = hub.stream("streamkey")
puts("before enable: #{stream.info.to_json}")

stream.enable()

stream = hub.get("streamkey")
puts("after enable: #{stream.info.to_json}")
# before disable: {"hub":"PiliSDKTest","key":"streamkey","disabled":true}
# after disable: {"hub":"PiliSDKTest","key":"streamkey","disabled":false}
```

#### Get Stream live status

```ruby
status = stream.live_status()
puts(status.to_json)
# {"startAt":1463022236,"clientIP":"222.73.202.226","bps":248,"fps":{"audio":45,"vedio":28,"data":0}}
```

#### Get Stream history activity 

```ruby
activity = stream.history_activity()
puts(activity.to_json)
# [{"start":1463022236,"end":1463022518}]
```

#### Save Stream live playback

```ruby
fname = stream.save()
puts(fname)
# recordings/z1.PiliSDKTest.streamkey/1463156847_1463157463.m3u8
```
