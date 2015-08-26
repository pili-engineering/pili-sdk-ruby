require 'pili'

# Replace with your keys here
ACCESS_KEY  = 'Qiniu_AccessKey'
SECRETE_KEY = 'Qiniu_SecretKey'

# Replace with your hub name
HUB_NAME = 'Pili_Hub_Name' # The Hub must be exists before use

# Change API host as necessary
# pili.qiniuapi.com as default
# pili-lte.qiniuapi.com is the latest RC version
# Pili::Config.init api_host: 'pili.qiniuapi.com' # default


# Instantiate an Pili hub
credentials = Pili::Credentials.new(ACCESS_KEY, SECRETE_KEY)
hub = Pili::Hub.new(credentials, HUB_NAME)
puts "Hub initialize =>\n#{hub.inspect}\n\n"


# hub

# Create a new Stream
begin
  title = nil            # optional, default is auto-generated
  publish_key = nil      # optional, a secret key for signing the <publishToken>
  publish_security = nil # optional, can be "dynamic" or "static", default is "dynamic"

  # stream = hub.create_stream()
  # or
  stream = hub.create_stream(title: title, publish_key: publish_key, publish_security: publish_security)
  puts "Hub create_stream() =>\n#{stream.inspect}\n\n"
rescue Exception => e
  puts "Hub create_stream() failed. Caught exception:\n#{e.http_body}\n\n"
end


# Get a Stream
begin
  stream = hub.get_stream(stream.id)
  puts "Hub get_stream() =>\n#{stream.inspect}\n\n"
rescue Exception => e
  puts "Hub get_stream() failed. Caught exception:\n#{e.http_body}\n\n"
end


# List streams
begin
  marker = nil # optional
  limit  = nil # optional
  title  = nil # optional
  streams = hub.list_streams(marker: marker, limit: limit, title: title)
  puts "Hub list_streams() =>\n#{streams.inspect}\n\n"
rescue Exception => e
  puts "Hub list_streams() failed. Caught exception:\n#{e.http_body}\n\n"
end


# Stream

# To JSON String
json_string = stream.to_json()
puts "Stream stream.to_json() =>\n#{json_string}\n\n"


# Update a Stream
begin
  publish_key = "new_secret_words" # optional, a secret key for signing the <publishToken>
  publish_security = "static"      # optional, can be "dynamic" or "static", default is "dynamic"
  disabled = nil                   # optional, can be true or false
  stream = stream.update(publish_key: publish_key, publish_security: publish_security, disabled: disabled)
  puts "Stream update() =>\n#{stream.inspect}\n\n"
rescue Exception => e
  puts "Stream update() failed. Caught exception:\n#{e.http_body}\n\n"
end


# Disable a Stream
begin
  stream = stream.disable()
  puts "Stream disable() =>\n#{stream.inspect}\n\n"
rescue Exception => e
  puts "Stream disable() failed. Caught exception:\n#{e.http_body}\n\n"
end


# Enable a Stream
begin
  stream = stream.enable()
  puts "Stream enable() =>\n#{stream.inspect}\n\n"
rescue Exception => e
  puts "Stream enable() failed. Caught exception:\n#{e.http_body}\n\n"
end


# Get stream status
begin
  status_info = stream.status()
  puts "Stream status() =>\n#{status_info.inspect}\n\n"
rescue Exception => e
  puts "Stream status() failed. Caught exception:\n#{e.http_body}\n\n"
end


# Generate RTMP publish URL
publish_url = stream.rtmp_publish_url()
puts "Stream rtmp_publish_url() =>\n#{publish_url}\n\n"


# Generate RTMP live play URLs
urls = stream.rtmp_live_urls()
puts "Stream rtmp_live_urls() =>\n#{urls.inspect}\n\n"


# Generate HLS live play URLs
urls = stream.hls_live_urls()
puts "Stream hls_live_urls() =>\n#{urls.inspect}\n\n"


# Generate HTTP-FLV live play URLs
urls = stream.http_flv_live_urls()
puts "Stream http_flv_live_urls() =>\n#{urls.inspect}\n\n"


# Get stream segments
begin
  start_time = nil  # optional, integer, in second, unix timestamp
  end_time   = nil  # optional, integer, in second, unix timestamp
  limit      = nil  # optional, uint
  segments = stream.segments(start_time: start_time, end_time: end_time, limit: limit)
  puts "Stream segments() =>\n#{segments.inspect}\n\n"
rescue Exception => e
  puts "Stream segments() failed. Caught exception:\n#{e.http_body}\n\n"
end


# Generate HLS playback URLs
start_time = 1440196065    # required, integer, in second, unix timestamp
end_time   = 1440196105    # required, integer, in second, unix timestamp
urls = stream.hls_playback_urls(start_time, end_time)
puts "Stream hls_playback_urls() =>\n#{urls.inspect}\n\n"



# Snapshot
begin
  name       = "imageName.jpg" # required, string
  format     = "jpg"           # required, string
  options = {
    :time       => 1440067100, # optional, int64, in second, unix timestamp
    :notify_url => nil         # optional
  }
  result = stream.snapshot(name, format, options)
  puts "Stream snapshot() =>\n#{result.inspect}\n\n"
rescue Exception => e
  puts "Stream snapshot() failed. Caught exception:\n#{e.http_body}\n\n"
end


# Save Stream as
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


# Delete a stream
begin
  result = stream.delete()
  puts "Stream delete() =>\n#{result.inspect}\n\n"
rescue Exception => e
  puts "Stream delete() failed. Caught exception:\n#{e.http_body}\n\n"
end
