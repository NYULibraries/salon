require 'rack/test'
require 'rspec'
require 'pry'
require 'rspec/its'

ENV['RACK_ENV'] = 'test'

Dir.glob('./app/{helpers,controllers}/*.rb').each { |file| require file }

module RSpecMixin
  include Rack::Test::Methods
end

RSpec.configure { |c| c.include RSpecMixin }
