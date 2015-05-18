# pili-ruby
=========

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

Pili.setup! access_key: '<YOUR_APP_ACCESS_KEY>',
			secret_key: '<YOUR_APP_SECRET_KEY>'
```

#### with rails:

You'll need to configure it in config/initializes/pili.rb


### Example

```ruby
# Replace with your customized domains
RTMP_PUBLISH_HOST = "xxx.pub.z1.pili.qiniup.com"
RTMP_PLAY_HOST 	  = "xxx.live1.z1.pili.qiniucdn.com"
HLS_PLAY_HOST     = "xxx.hls1.z1.pili.qiniucdn.com"

# Replace with your hub name
HUB_NAME = "hub_name"
```


#### Create Stream

```ruby
# HUB_NAME: string, required
# title: optional, default is auto-generated
# publish_key: optional, a secret key for signing the <publishToken>
# publish_security: optional, can be "dynamic" or "static", default is "dynamic"
Pili.create_stream(HUB_NAME, title: title, publish_key: publish_key, publish_security: publish_security)
```

#### Get Stream

```ruby
# stream_id: string, required
Pili.get_stream(stream_id)
```

#### Update Stream

```ruby
# stream_id: string, required
# publish_key: optional, a secret key for signing the <publishToken>
# publish_security: optional, can be "dynamic" or "static", default is "dynamic"
Pili.update_stream(stream_id, publish_key: publish_key, publish_security: publish_security)
```

#### Get Stream List

```ruby
# HUB_NAME: string, required
# marker: string, optional
# limit: integer, optional
Pili.stream_list(HUB_NAME, marker: marker, limit: limit)
```

#### Delete Stream

```ruby
# stream_id: string, required
Pili.delete_stream(stream_id)
```

#### Get Stream Segments

```ruby
# stream_id: string, required
# start, end: unix timestamp, optional
Pili.get_stream_segments(stream_id, start: timestamp, end: timestamp)
```

#### Get Stream Publish URL

```ruby
# RTMP_PUBLISH_HOST, string, required
# stream_id: string, required
# publish_key: string, required
# publish_security: string, required
# nonce: unix timestamp, optional
Pili.get_stream_publish_url(RTMP_PUBLISH_HOST, stream_id, publish_key, publish_security, nonce)
```

#### Get Stream RTMP Live URL

```ruby
# RTMP_PLAY_HOST, string, required
# stream_id: string, required
# profile: string, optional
Pili.get_stream_rtmp_live_url(RTMP_PLAY_HOST, stream_id, profile)
```

#### Get Stream HLS Live URL

```ruby
# HLS_PLAY_HOST, string, required
# stream_id: string, required
# profile: string, optional
Pili.get_stream_hls_live_url(HLS_PLAY_HOST, stream_id, profile)
```

#### Get Stream HLS Playback URL

```ruby
# HLS_PLAY_HOST, string, required
# stream_id: string, required
# start_second, end_second: unix timestamp, required
# profile: string, optional
Pili.get_stream_hls_playback_url(HLS_PLAY_HOST, stream_id, start_second, end_second, profile)
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Contributors

See the [Contributors List](https://github.com/pili-io/pili-sdk-ruby/graphs/contributors).
