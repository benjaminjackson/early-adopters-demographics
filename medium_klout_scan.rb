require 'klout-rb'
require 'open-uri'

BUCKETS = [(0...25), (25...50), (50...75), (75...100)]

raise "Please specify an input file" if ARGV[0].nil?

Klout::Client.configure do |config|
  config.api_key = "9bavesxxw57b7xxbuzeddafy"
end

open(ARGV[0]).each_line do |screen_name|
  begin
  user = Klout::Client.score(screen_name.chomp)
  bucket = BUCKETS.find { |b| b.include? user.score.floor }
  puts "#{screen_name.chomp}\t#{user.score}\t#{bucket}"
  rescue Exception => e
    puts "#{screen_name.chomp}\terror\tNo score"
  end
end