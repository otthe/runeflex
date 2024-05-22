#require 'sinatra'
require 'sinatra/base'
require './scraper.rb'
require './generator.rb'
require_relative 'rate_limiter'

require 'redis'


class RuneFlex < Sinatra::Base
  use RateLimiter, limit: 100, period: 60

  before do
    logger.info "Received request: #{request.path}"
  end


  get '/flex' do
    content_type 'image/svg+xml'

    unless params[:rsn]
      status 400
      return 'error: missing username params'
    end

    if params[:rsn].length > 12
      status 400
      return 'error: username must be 12 characters or less'
    end

    rsn = params[:rsn]

    scraper = Scraper.new(rsn.to_s)
    stats = scraper.stats
    generator = Generator.new()
    generator.generate_stats_svg(stats, rsn)
  end

  run! if app_file == $0
end









# get '/flex' do
#   content_type 'image/svg+xml'

#   unless params[:rsn]
#     status 400
#     return 'error: missing username params'
#   end

#   if params[:rsn].length > 12
#     status 400
#     return 'error: username must be 12 characters or less'
#   end

#   rsn = params[:rsn]

#   scraper = Scraper.new(rsn.to_s)
#   stats = scraper.stats
#   generator = Generator.new()
#   generator.generate_stats_svg(stats, rsn)
# end
