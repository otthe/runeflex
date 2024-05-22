require 'sinatra'

require './scraper.rb'
require './generator.rb'

get '/flex' do
  content_type 'image/svg+xml'

  unless params[:rsn]
    status 400
    return 'error missing username params'
  end

  rsn = params[:rsn]

  scraper = Scraper.new(rsn.to_s)
  stats = scraper.stats
  puts stats
  generator = Generator.new()
  generator.generate_stats_svg(stats, rsn)
end
