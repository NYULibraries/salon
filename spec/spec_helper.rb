require 'coveralls'
Coveralls.wear!
require 'rack/test'
require 'rspec'
require 'pry'
require 'rspec/its'

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
end
