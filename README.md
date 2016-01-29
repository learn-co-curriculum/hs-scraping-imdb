

## Scraping IMDB
![Teenage Mutatnt Ninja Turtles](http://cdn.fansided.com/wp-content/blogs.dir/98/files/2014/07/watch-teenage-mutant-ninja-turtles-season-2-episode-16-online-the-lonely-mutation-of-baxter-stockman-threatens-to-mutate-april-is-the-new-n.png)

We're going to move from a curated example of scraping to a REAL WORLD application of scraping! Have you heard of IMDb? It's only the coolest movie site ever to exist on the planet. IMDb stands for the Internet Movie Database. Let's say you were going to build a website or app that showcases your favorite movies. Would you want to manually type in all of the information for every movie that you've enjoyed? No, you proabably would rather automate the process. That's where the power of scraping comes in.

We want to be able to feed our scraper a url of a movie from IMDb and have it pull out the relevent/interesting facts that we'll display in our own application. We'll start with a specific page (http://www.imdb.com/title/tt1291150/?ref_=cht_bo_8) and then make our code object oriented so that we can scrape any movie site.

###Step 1: Set Up

As we've learned before, we need to require Nokogiri and Open-Uri, and get the HTML of the site we want, and then convert it to a nokogiri object:

```ruby
require 'nokogiri'
require 'open-uri'

imdb_html = open("http://www.imdb.com/title/tt1291150/?ref_=cht_bo_8")
imdb_nokogiri = Nokogiri::HTML(imdb_html)

```

Let's look at the imdb page and figure out what we want. Hmm... How about:
+ Movie Title
+ Director
+ Stars
+ Storyline
+ MPAA Rating

#### Title
We'll start with movie title. Remember, we have to use the `css` method with the correct CSS selector to pull out the information we want and set it equal to a variable. Use Chrome Dev tools to inspect the page and find the html elements with the information you want. Then use the CSS path at the bottom of the inspector to get the correct css selector. This one is pretty straightforward.

```ruby
  movie_title = imdb_nokogiri.css("h1 span.itemprop").text
```

If we now `puts movie_title`, we see "Teenage Mutant Ninja Turtles"

#### Director
Next is getting the film's director, which we'll get in a similar way. When we inspect the director element, we see it is in a div with an 'itemprop' attribute set to 'director'. Here's how we can use CSS selectors to get an element with a custom attribute:

```ruby
  director = imdb_nokogiri.css("div[itemprop=director]")
```
This returns us an array, which if we convert to text gives us too much information("\n        Director:\nJonathan Liebesman\n    "). Notice that the array has a node called "children". If we add `.children` to our code `director = imdb_nokogiri.css("div[itemprop=director]").children` then we get an array of the items in the first array's "children node". Look carefully in that array and you'll see that the fourth item is the director's name. We can pull that out using the index:

```ruby
  director = imdb_nokogiri.css("div[itemprop=director]").children[3].text
``` 
*This isn't easy at first, and requires a lot of trial and error. Get help if you need it from classmates, friends, instructors, Google, and Stack Overflow!*

#### Stars
Let's get the movie's stars. Once again, use dev tools to get to the data you want. In this case there may be multiple actor names, each inside its own html element. This makes getting the data we want a little more complicated, but also a little more exciting! We'll want to get an array of all of the stars. First, let's find the elements that contain the actors names.

It looks like it we can select this data by using the following CSS selector: `@imdb_nokogiri.css('div[itemprop=actors] a span')`. This means that the data is inside of a `span` tag, which is inside of an `a` tag, which is inside of `div` tag with an attribute of "itemprop" that is set to "actors". 
  ```ruby
    stars = @imdb_nokogiri.css('div[itemprop=actors] a span')
  ```
From there, if we `puts` our code with the `text` method, we'll get something pretty ugly: "Megan FoxWill ArnettWilliam Fichtner". This is because we are calling the `text` method on several several spans, instead of each one individually. Let's do this instead by using an iterator:
```ruby
  stars = @imdb_nokogiri.css('div[itemprop=actors] a span')
  stars_array = stars.collect { |star| star.text }
```
This now returns an array with the actors' names. To get this in to a pretty string format where the names are separated by commas, we'd call the `join` method on our new array:

```ruby
movie_stars = stars_array.join(", ")
```

#### Storyline
To get the description of the movie, we see that it's in a p tag within a div with `itemprop="description"`. This would look like this:

```ruby
  storyline = @imdb_nokogiri.css('div[itemprop=description] p')
```
If we `puts` our storyline variable now, we see that we get some extra space and  "written by Paramount Pictures" as well as some html tags. If we only want the main description, we can dig deeper using the `children` method. We then use the `text` method to convert the object to text, and the `strip` method to get rid of any spaces at the beginning or the end of the string.

```ruby
  storyline = @imdb_nokogiri.css('div[itemprop=description] p').children.first.text.strip
```

#### MPAA rating.
Phew. Our last one. This one is pretty straightforward:
```ruby
mpaa_rating = @imdb_nokogiri.css('span[itemprop=contentRating]').text
```

### Making it all Object Oriented!
Let's make our scraper object oriented, so that it's easily mutable and extensible! Start with the class:

```ruby
class ScrapeImdb
end
```
Add in an initialize method, that takes the imdb url as an argument.
```ruby
class ScrapeImdb
  def initialize(site)
    imdb_html = open(site)
    @imdb_nokogiri = Nokogiri::HTML(imdb_html)
  end
end
```
We make the imdb_nokogiri variable an instance variable using `@` so that it can be read by other methods in the class.

Last, we convert each of our different movie parts that we scraped in to their own methods, being sure to update `imdb_nokogiri` to `@imdb_nokogiri`. Here's the final code!:

```ruby

require 'nokogiri'
require 'open-uri'

class IMDbScraper

  def initialize(site)
    @site = site
    @imdb_html = open(site)
    @imdb_nokogiri = Nokogiri::HTML(@imdb_html)
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
```

Let's add in one last method that takes all of the scraped data and puts it in a well formatted string:
```ruby
  def get_all_info
    "Movie: #{get_movie_title}\nDirector: #{get_director}\nStars: #{get_stars}\nStoryline: #{get_storyline}\nRating: #{get_mpaa_rating}\n"
  end
  ```

  Now, let's see if it works!
  ```
  shawshank = IMDbScraper.new("http://www.imdb.com/title/tt0111161/?ref_=nv_sr_1")
  puts shawshank.get_all_info
  ```
  This returns:

  >Movie: The Shawshank Redemption

  >Director: Frank Darabont

  >Stars: Tim Robbins, Morgan Freeman, Bob Gunton

  >Storyline: Andy Dufresne is a young and successful banker whose life changes drastically when he is convicted and sentenced to life imprisonment for the murder of his wife and her lover. Set in the 1940's, the film shows how Andy, with the help of his friend Red, the prison entrepreneur, turns out to be a most unconventional prisoner.
  
  >Rating: Rated R for language and prison violence



<p data-visibility='hidden'>View <a href='https://learn.co/lessons/hs-scraping-imdb' title='Scraping IMDB'>Scraping IMDB</a> on Learn.co and start learning to code for free.</p>
