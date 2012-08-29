require 'open-uri'
require 'nokogiri'

open(ARGV[0]).each_line do |uri|
  doc = Nokogiri::HTML(open(uri))
  puts uri.chomp + "\t" + doc.css('.magnitude-value').first.text
end
