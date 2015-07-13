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

- [Installation](#Installation)
- [Usage](#Usage)
  - [Configuration](#Configuration)
  - [Client](#Client)
    - [Create a Pili client](#Create-a-Pili-client)
    - [Create a stream](#Create-a-stream)
    - [Get a stream](#Get-a-stream)
    - [List streams](#List-streams)
  - [Stream](#Stream)
      - [Update a stream](#Update-a-stream)
    - [Delete a stream](#Delete-a-stream)
    - [Get stream segments](#Get-stream-segments)
    - [Get stream status](#Get-stream-status)
    - [Generate RTMP publish URL](#Generate-RTMP-publish-URL)
    - [Generate RTMP live play URL](#Generate-RTMP-live-play-URL)
    - [Generate HLS live play URL](#Generate-HLS-live-play-URL)
    - [Generate HLS playback URL](#Generate-HLS-playback-URL)
    - [To JSON String](#To-JSON-String)
- [History](#History)

## Installaion

Pili SDK for Ruby.

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

ACCESS_KEY = 'QiniuAccessKey';
SECRETE_KEY = 'QiniuSecretKey';

HUB = 'hubName';
```

### Client

#### Create a Pili client

```ruby
client = Pili::Client.new(ACCESS_KEY, SECRETE_KEY, HUB)
```

#### Create a stream

```ruby
# title: optional, default is auto-generated
# publish_key: optional, a secret key for signing the <publishToken>
# publish_security: optional, can be "dynamic" or "static", default is "dynamic"
client.create_stream(title: "test", publish_key: "werqwedsf", publish_security: "static")
```

#### Get a stream

```ruby
# stream_id: string, required
client.get_stream(stream_id)
```

#### List streams

```ruby
# HUB_NAME: string, required
# marker: string, optional
# limit: integer, optional
client.list_streams(HUB_NAME, marker: "marker", limit: 1000)
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
```

#### Get stream status

```ruby
stream.status()
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
  - Init sdk
  - Add Stream API
  - Add publish and play policy