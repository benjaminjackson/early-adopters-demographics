require 'nokogiri'
require 'open-uri'

raise "Please specify a file on the command line" if ARGV.empty?
doc = Nokogiri::HTML(open(ARGV[0]))
screen_names = []
doc.css("div.post-container").each do |container|
  screen_names << container['data-post-author-username']
end
sorted_screen_names = screen_names.sort.uniq
puts sorted_screen_names.sample(980).join("\n")