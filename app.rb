require 'sinatra'

require './scraper.rb'
require './generator.rb'



# get '/' do
#   scraper = Scraper.new("Wrath tiara")
#   stats = scraper.stats
#   generator = Generator.new()
#   #generator.generate_svg_template(stats)
#   puts stats
# end


get '/flex/' do
  content_type 'image/svg+xml'
  scraper = Scraper.new("Wrath tiara")
  stats = scraper.stats
  generator = Generator.new()
  svg = generator.svg
  svg.render
end