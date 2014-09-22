require 'pry'
require 'nokogiri'
require 'open-uri'

class IMDbScraper

	def initialize(site)
		imdb_html = open(site)
		@imdb_nokogiri = Nokogiri::HTML(imdb_html)
	end

	def get_all_info
		"Movie: #{get_movie_title}\nDirector: #{get_director}\nStars: #{get_stars}\nStoryline: #{get_storyline}\nRating: #{get_mpaa_rating}\n"
	end

	def get_movie_title
		movie_title = @imdb_nokogiri.css('h1 span.itemprop').text
	end

	def get_director
		director = @imdb_nokogiri.css('div[itemprop=director]').children[3].text
	end

	def get_stars
		stars = @imdb_nokogiri.css('div[itemprop=actors] a span')
		stars_array = stars.collect do |star| 
									 	star.text
									end
		stars_array.join(", ")
	end

	def get_storyline
		storyline = @imdb_nokogiri.css('div[itemprop=description] p').children.first.text.strip
	end

	def get_mpaa_rating
		mpaa_rating = @imdb_nokogiri.css('span[itemprop=contentRating]').text
	end
end

scraper = IMDbScraper.new('http://www.imdb.com/title/tt0111161/')
puts scraper.get_all_info