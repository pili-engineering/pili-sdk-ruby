require 'piliv2'

access_key = ENV["PILI_ACCESS_KEY"]
secret_key = ENV["PILI_SECRET_KEY"]

hub_name = ENV["PILI_HUB_NAME"]

if access_key == nil || secret_key == nil
  raise 'access_key = #{access_key} secret_key = #{secret_key}'
end

srand
stream_key_prefix = "ruby-sdkexample-#{rand 1000000000}"

puts "初始化 client."
mac = Pili::Mac.new access_key, secret_key
client = Pili::Client.new mac
hub = client.hub hub_name

puts "获得不存在的流."
key_a = stream_key_prefix + "-a"
begin
  stream_a = hub.stream key_a
  stream_a.info
rescue Pili::ResourceNotExist => e
  puts e
end

puts "创建流."
stream_a = hub.create(key_a)
puts stream_a.info

puts "获得流."
stream_a = hub.stream(key_a)
puts "to_json: #{stream_a.info.to_json}"

puts "创建重复的流."
begin
  hub.create(key_a)
rescue Pili::ResourceConflict => e
  puts e
end

puts "创建另一路流."
key_b = stream_key_prefix + "-b"
stream_b = hub.create(key_b)
puts stream_b.info

puts "列出所有流."
begin
  keys, marker = hub.list(:prefix=>stream_key_prefix)
  puts keys.to_s, marker
rescue Pili::ResourceNotExist => e
  puts e
end

puts "列出正在直播的流."
begin
  keys, marker = hub.list_live(:prefix=>stream_key_prefix)
  puts keys.to_s, marker
rescue Pili::ResourceNotExist => e
  puts e
end

puts "禁用流."
stream_a.disable()
puts stream_a.info

puts "启用流."
stream_a.enable()
puts stream_a.info

puts "禁用流 10 秒"
puts("before disable: #{stream_a.info.to_json}")

stream_a.disable_till(Time.now.to_i + 10)

puts("after disable: #{stream_a.info.to_json}")

sleep(10)

puts("after 10 seconds: #{stream_a.info.to_json}")

puts "查询直播状态."
begin
  status = stream_a.live_status()
  puts keys, marker
rescue Pili::ResourceNotExist => e
  puts e
end

puts "更改流的实时转码规格"
puts stream_a.info.to_json
stream_a.update_converts(["720p", "480p"])
puts stream_a.info.to_json

puts "查询推流历史."
activity = stream_a.history_activity()
puts activity

puts "保存直播数据."
begin
  fname, persistentID = stream_a.saveas(:format => "mp4")
  puts fname, persistentID
rescue => e
  puts e
end

puts "RTMP 推流地址."
url = Pili.rtmp_publish_url("publish-rtmp.test.com", hub_name, key_a, mac, 3600)
puts url

puts "RTMP 直播放址."
url = Pili.rtmp_play_url("live-rtmp.test.com", hub_name, key_a)
puts url

puts "HLS 直播地址."
url = Pili.hls_play_url("live-hls.test.com", hub_name, key_a)
puts url

puts "HDL 直播地址."
url = Pili.hdl_play_url("live-hdl.test.com", hub_name, key_a)
puts url

puts "截图直播地址"
url = Pili.snapshot_play_url("live-snapshot.test.com", hub_name, key_a)
puts url
