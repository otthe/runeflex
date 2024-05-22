require 'rack/test'
require 'rspec'
require_relative '../app'

RSpec.describe RuneFlex do
include Rack::Test::Methods

  def app
    RuneFlex
  end

  context 'when the rate limit is not exceeded' do
    it 'returns a 200 OK status' do
      get '/'
      expect(last_response.status).to eq(200)
    end
  end

  context 'when the rate limit is exceeded' do
    it 'returns a 429 Too Many Requests error' do
      101.times { get '/' }
      expect(last_response.status).to eq(429)
    end
  end

end