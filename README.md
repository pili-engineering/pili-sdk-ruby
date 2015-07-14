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
    - [Generate RTMP live play URL](#generate-rtmp-live-play-urls)
    - [Generate HLS live play URL](#generate-hls-live-play-url)
    - [Generate HLS playback URL](#generate-hls-playback-url)
    - [To JSON String](#to-json-string)
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
```

#### Delete a stream

```ruby
stream.delete()
```

#### Get stream segments

```ruby
# start_second: integer, optional
# end_second: integer, optional
stream.segments(start_second, end_second)

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
```

#### Generate RTMP live play URLs

```ruby
stream.rtmp_live_urls()
```

#### Generate HLS live play URLs

```ruby
stream.hls_live_urls()
```

#### Generate HLS playback URLs

```ruby
stream.hls_playback_urls()
```

#### To JSON String
```ruby
stream.to_json()
```

## History

- 2.0.0
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