require 'pry'
require 'nokogiri'
require 'open-uri'

imdb_html = open('http://www.imdb.com/title/tt1291150/?ref_=hm_cht_t4')

imdb_nokogiri = Nokogiri::HTML(imdb_html)

movie_title = imdb_nokogiri.css('h1 span.itemprop').text

director = imdb_nokogiri.css('div.txt-block').first.children[3].text

stars = imdb_nokogiri.css('div.txt-block')[2].css('a span')
stars_array = stars.children.collect do |star| 
	star.text
end

storyline = imdb_nokogiri.css('div[itemprop=description]').children[1].children[0].text.strip

mpaa_rating = imdb_nokogiri.css('span[itemprop=contentRating]').text

budget = imdb_nokogiri.css('div.txt-block').select{|div| div.text.match(/Budget/)}.first.children[2].text.strip

gross = imdb_nokogiri.css('div.txt-block').select{|div| div.text.match(/Gross/)}.first.children[2].text.strip
