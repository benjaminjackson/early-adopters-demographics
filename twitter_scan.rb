require 'open-uri'
require 'twitter'
require './config'

BUCKETS = [(0...200), (200...1000), (1000...5000), (5000...10000), (10000...50000), (50000...100000), (100000...500000), (500000...1000000), (1000000...5000000)]

open(ARGV[0]).each_line do |screen_name|
  user = Twitter.user(screen_name)
  bucket = BUCKETS.find { |b| b.include?(user.followers_count) }
  puts [user.screen_name, user.followers_count, bucket.to_s].join("\t")
end