require 'coveralls'
Coveralls.wear!
require 'rack/test'
require 'rspec'
require 'pry'
require 'rspec/its'
require 'rest-client'

ENV['RACK_ENV'] = 'test'

Dir.glob('./app/{helpers,controllers}/*.rb').each { |file| require file }
Dir.glob('./spec/support/**/*.rb').each { |file| require file }

module RSpecMixin
  include Rack::Test::Methods
end

RSpec.configure do |config|
  config.include RSpecMixin

  config.around(:each) do |example|
    VCR.use_cassette('oauth') do
      example.run
    end
  end

  config.before(:all) do
    # request non-admin token
    TOKEN_URL = 'https://dev.login.library.nyu.edu/oauth/token' unless defined?(TOKEN_URL)
    payload = {
      grant_type: "client_credentials",
      client_id: ENV['TEST_CLIENT_ID'],
      client_secret: ENV['TEST_CLIENT_SECRET'],
    }
    response = RestClient.post(TOKEN_URL, payload)
    ENV['TOKEN'] = JSON.parse(response.body)['access_token']
    # request admin token
    payload[:scope] = 'admin'
    response = RestClient.post(TOKEN_URL, payload)
    ENV['ADMIN_TOKEN'] = JSON.parse(response.body)['access_token']
  end
end
