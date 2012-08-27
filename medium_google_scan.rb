require 'oj'
require 'nokogiri'
require 'open-uri'
require 'date'

START_DATE = DateTime.parse("2012-07-31")
END_DATE = Date.today

(START_DATE...END_DATE).each do |datetime|
  puts "Checking for #{datetime.strftime("%^B %-d %Y")}"

  done = false
  offset = 0
  total_results = 0

  while !done
    # Shortcut
    dict = Oj.load(open(%(http://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=site:medium.com%2Fp%2F+%22#{datetime.strftime("%^B")}+#{datetime.strftime("%-d")}%2C+#{datetime.strftime("%Y")}%22&start=#{offset}&key=AIzaSyAjwaJXfSv5SIsh5JycfcilhGSAmwHoC8g)))
    results = []
    
    if dict['responseData']  
      results = dict['responseData']['results'].map { |result| result['url'] }
      offset += results.length
    elsif dict['responseDetails'].match(/quota/i)
      puts dict.inspect
      raise "Over quota"
    end
    
    results.reject { |uri| uri == "http://medium.com/"}.each do |uri|
      doc = Nokogiri::HTML(open(uri))
      authors = []
      doc.css('a.post-author-image, a.post-author').each do |link|
        authors << link.attributes["href"].value.sub("http://twitter.com/", "")
      end
      puts uri + "\t" + authors.sort.uniq.flatten.join(" ")
    end
    
    total_results += results.length
    done = total_results >= dict['responseData']['cursor']['resultCount'].to_i
    sleep 10
  end

end