require 'pry'
require 'nokogiri'
require 'open-uri'

class ImdbScraper

	def initialize(site)
		@site = site
		@imdb_html = open(site)
		@imdb_nokogiri = Nokogiri::HTML(@imdb_html)
	end

	def get_all_info
		"Movie: #{get_movie_title}\n
		Director: #{get_director}\n
		Stars: #{get_stars}\n
		Storyline: #{get_storyline}\n
		Rating: #{get_mpaa_rating}\n
		Budget: #{get_budget}\n
		Gross: #{get_gross}"
	end

	def get_movie_title
		movie_title = @imdb_nokogiri.css('h1 span.itemprop').text
	end

	def get_director
		director = @imdb_nokogiri.css('div.txt-block').first.children[3].text
	end

	def get_stars
		stars = @imdb_nokogiri.css('div.txt-block')[2].css('a span')
		stars_array = stars.children.collect do |star| 
			star.text
		end
	end

	def get_storyline
		storyline = @imdb_nokogiri.css('div[itemprop=description]').children[1].children[0].text.strip
	end

	def get_mpaa_rating
		mpaa_rating = @imdb_nokogiri.css('span[itemprop=contentRating]').text
	end

	def get_budget
		budget_match = @imdb_nokogiri.css('div.txt-block').select{|div| div.text.match(/Budget/)}
		if budget_match.length > 0
			budget_match.first.children[2].text.strip
		else
			"No budget listed"
		end
	end

	def get_gross
		gross_match = @imdb_nokogiri.css('div.txt-block').select{|div| div.text.match(/Gross/)}
		if gross_match.length > 0 
			gross_match.first.children[2].text.strip
		else
			"No gross listed"
		end
	end

end

scraper = ImdbScraper.new('http://www.imdb.com/title/tt1291150/?ref_=hm_cht_t4')
puts scraper.get_all_info
