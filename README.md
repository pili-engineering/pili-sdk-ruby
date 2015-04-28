# pili-ruby
=========

pili-io Ruby SDK

## Installation

Add this line to your application's Gemfile:

    gem 'pili'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pili

## Usage

### Initialize

	require 'pili'
	
	Pili.setup! access_key: '<YOUR_APP_ACCESS_KEY>', 
				secret_key: '<YOUR_APP_SECRET_KEY>'	
#### with rails:

You'll need to configure it in config/initializes/pili.rb


### Create Stream

	Pili.create_stream(hub_name)
	
	# with options
	stream_options = {
		title:				"test_name", 	# optional, default is auto-generated
        publish_key:		"test_key",   	# optional, a secret key for signing the <publishToken>
        publish_security: 	"dynamic"		# optional, can be "dynamic" or "static", default is "dynamic"
	}

	Pili.create_stream(hub_name, stream_options)

### Get Stream

	Pili.create_stream(stream_id)
	
### Update Stream

	Pili.update_stream(stream_id, publish_key: publish_key, publish_security: publish_security)
	
### Get Stream List

	Pili.stream_list(hub)
	
	# marker, limit: integer, optional
	Pili.stream_list(hub, marker: marker, limit: limit)

### Delete Stream

	Pili.delete_stream(stream_id)
	
### Get Stream Segments
	Pili.get_stream_segments(stream_id)
	
	# start, end: integer, optional
	Pili.get_stream_segments(stream_id, start: timestamp, end: timestamp)

### Get Stream Publish URL

	Pili.get_stream_publish_url(stream_id, publish_key, publish_security)
	Pili.get_stream_publish_url(stream_id, publish_key, publish_security, timestamp)
	
### Get Stream RTMP Live URL

	Pili.get_stream_rtmp_live_url(stream_id)
	Pili.get_stream_rtmp_live_url(stream_id, preset)

### Get Stream HLS Live URL

	Pili.get_stream_hls_live_url(stream_id)
	Pili.get_stream_hls_live_url(stream_id, preset)
	
### Get Stream HLS Playback URL

	Pili.get_stream_hls_playback_url(stream_id, start_second, end_second)
	Pili.get_stream_hls_playback_url(stream_id, start_second, end_second, preset)
	

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Contributors

See the [Contributors List](https://github.com/pili-io/pili-sdk-ruby/graphs/contributors).
