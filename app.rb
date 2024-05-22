require 'sinatra'

require './scraper.rb'


get '/' do
  scraper = Scraper.new("Wrath tiara")
  stats = scraper.stats
  puts stats
end


get '/flex/' do
  content_type 'image/svg+xml'
  scraper = Scraper.new("Wrath tiara")
  stats = scraper.stats
  puts stats
end