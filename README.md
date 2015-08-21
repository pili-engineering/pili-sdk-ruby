# Pili server-side library for Ruby

## Features

- [x] Stream operations (Create, Delete, Update, Get)
- [x] Get Streams list
- [x] Get Stream status
- [x] Get Stream segments
- [x] Generate RTMP publish URL
- [x] Generate RTMP / HLS live play URL
- [x] Generate HLS playback URL

## Content

- [Installation](#installation)
- [Usage](#usage)
  - [Configuration](#configuration)
  - [Client](#client)
    - [Create a Pili client](#create-a-pili-client)
    - [Create a stream](#create-a-stream)
    - [Get a stream](#get-a-stream)
    - [List streams](#list-streams)
  - [Stream](#stream)
    - [Update a stream](#update-a-stream)
    - [Delete a stream](#delete-a-stream)
    - [Get stream segments](#get-stream-segments)
    - [Get stream status](#get-stream-status)
    - [Generate RTMP publish URL](#generate-rtmp-publish-url)
    - [Generate RTMP live play URLs](#generate-rtmp-live-play-urls)
    - [Generate HLS live play URLs](#generate-hls-live-play-urls)
    - [Generate HLS playback URLs](#generate-hls-playback-urls)
    - [To JSON String](#to-json-string)
    - [Save Stream as](#save-stream-as)
    - [Enable](#enable)
    - [Disable](#disable)
    - [Snapshot](#snapshot)
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

ACCESS_KEY = 'qiniu_access_key'
SECRETE_KEY = 'qiniu_secret_key'

HUB_NAME = 'hub_name'
```

### Client

#### Create a Pili client

```ruby
client = Pili::Client.new(ACCESS_KEY, SECRETE_KEY, HUB_NAME)
# return client object...
```

#### Create a stream

```ruby
# title: optional, default is auto-generated
# publish_key: optional, a secret key for signing the <publishToken>
# publish_security: optional, can be "dynamic" or "static", default is "dynamic"
client.create_stream()
# or
client.create_stream(title: "title", publish_key: "publish_key", publish_security: "static")
# return stream object...
```

#### Get a stream

```ruby
# stream_id: string, required
client.get_stream(stream_id)
# return stream object...
```

#### List streams

```ruby
# marker: string, optional
# limit: integer, optional
client.list_streams(marker: "marker", limit: 1000)
```

### Stream

#### Update a stream

```ruby
# publish_key: optional, a secret key for signing the <publishToken>
# publish_security: optional, can be "dynamic" or "static", default is "dynamic"
# disabled: optional, can be true or false
stream.update(publish_key: "new_key", publish_security: "dynamic", disabled: true)
# return updated stream object...
```

#### Delete a stream

```ruby
stream.delete()
```

#### Get stream segments

```ruby
# start_time: optional, integer, in second, unix timestamp
# end_time:   optional, integer, in second, unix timestamp
stream.segments()
# or
stream.segments(start_time, end_time)

# [
#   {
#     "start": <StartSecond>,
#     "end": <EndSecond>
#   },
#   {
#     "start": <StartSecond>,
#     "end": <EndSecond>
#   },
#   ...
# ]
```

#### Get stream status

```ruby
stream.status()
# {
#   "addr": "106.187.43.211:51393",
#   "status": "disconnected"
# }
```

#### Generate RTMP publish URL

```ruby
stream.rtmp_publish_url()
# return a rtmp publish url, eg. "rtmp://test.qiniucdn.com/hubname/test?key=publish_test_key"
```

#### Generate RTMP live play URLs

```ruby
urls = stream.rtmp_live_urls()
# return rtmp live play urls, eg.
# {
#   "ORIGIN" => "rtmp://test.qiniucdn.com/hubname/test",
#   "240p" => "rtmp://test.qiniucdn.com/hubname/test@240p",
#   ...
# }

# Get original RTMP live url
original_url = urls['ORIGIN']
```

#### Generate HLS live play URLs

```ruby
stream.hls_live_urls()
# return hls live play urls, eg.
# {
#   "ORIGIN" => "http://test.qiniucdn.com/hubname/test.m3u8",
#   "240p" => "http://test.qiniucdn.com/hubname/test@240p.m3u8"
#   ...
# }

# Get original HLS live url
original_url = urls['ORIGIN']
```

#### Generate HLS playback URLs

```ruby
# start_time: optional, integer, in second, unix timestamp
# end_time:   optional, integer, in second, unix timestamp
stream.hls_playback_urls(start_time, end_time)
# return hls playback urls, eg.
# {
#   "ORIGIN" => "http://test.qiniucdn.com/hubname/test.m3u8?start=1436843430&end=1436846938",
#   "240p" => "http://test.qiniucdn.com/hubname/test@240p.m3u8?start=1436843430&end=1436846938"
#   ...
# }

# Get original HLS playback url
original_url = urls['ORIGIN']
```

#### To JSON String
```ruby
stream.to_json()
```

#### Save Stream as
```ruby
# name       = "fileName" # required, string
# format     = "mp4"      # required, string
# start_time = 1439121809 # required, int64, in second, unix timestamp
# end_time   = 1439125409 # required, int64, in second, unix timestamp
# options = {
#   :notify_url => "http://remote_callback_url"
# } #optional

stream.save_as(name, format, start_time, end_time, options)

# return a dictionary:
# {
#   "url": "<m3u8Url>",
#   "targetUrl": "<TargetFileUrl>",
#   "persistentId": <PersistentId>
# }
#
# You can get saving state via Qiniu fop service using persistentId.
# API: `curl -D GET http://api.qiniu.com/status/get/prefop?id=<PersistentId>`
# Doc reference: `http://developer.qiniu.com/docs/v6/api/overview/fop/persistent-fop.html#pfop-status`
```

#### Enable
```ruby
stream.enable()
```

#### Disable
```ruby
stream.disable()
```

#### Snapshot
```ruby
# name       = "fileName" # required, string
# format     = "jpg"      # required, string
# options = {
#   :time       => 1439125409                   # optional, int64, in second, unix timestamp
#   :notify_url => "http://remote_callback_url" # optional
# }

stream.snapshot(name, format, options)

# return a dictionary:
# {
#   "targetUrl": "<TargetUrl>",
#   "persistentId": <persistentId>
# }
```

## History
- 1.4.0
  - Add get stream http flv live urls function feature
  - Add stream disable function feature
  - Add stream enable function feature
  - Add stream snapshot function feature
- 1.3.0
  - Add stream saveas function
- 1.2.0
  - Add Client, Stream class
- 1.0.1
  - Add get stream status method.
  - Update update_stream method.
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