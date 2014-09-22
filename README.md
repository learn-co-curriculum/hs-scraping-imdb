---
tags: nokogiri, scraping, kids
language: ruby
level: 3
type: walkthrough, demo
---

## Scraping IMDB

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
+ Budget
+ Box Office Gross

We'll start with movie title. Remember, we have to use the `css` method with the correct CSS selector to pull out the information we want and set it equal to a variable. Use Chrome Dev tools to inspect the page and find the html elements with the information you want. Then use the CSS path at the bottom of the inspector to get the correct css selector. This one is pretty straightforward.

```ruby
  movie_title = imdb_nokogiri.css("h1 span.itemprop").text
```

If we now `puts movie_title`, we see "Teenage Mutant Ninja Turtles"

Next is getting the film's director, which we'll get in a similar way. When we inspect the director element, we see it is in a div with an 'itemprop' attribute set to 'director'. Here's how we can use CSS selectors to get an element with a custom attribute:

```ruby
  director = imdb_nokogiri.css("div[itemprop=director]")
```
This returns us an array, which if we convert to text gives us too much information("\n        Director:\nJonathan Liebesman\n    "). Notice that the array has a node called "children". If we add `.children` to our code `director = imdb_nokogiri.css("div[itemprop=director]").children` then we get an array of the items in the first array's "children node". Look carefully in that array and you'll see that the fourth item is the director's name. We can pull that out using the index:

```ruby
  director = imdb_nokogiri.css("div[itemprop=director]").children[3].text
``` 
*This isn't easy at first, and requires a lot of trial and error. Get help if you need it from classmates, friends, instructors, Google, and Stack Overflow!*

