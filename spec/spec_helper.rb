require 'rack/test'
require 'rspec'
require 'pry'
require 'rspec/its'

ENV['RACK_ENV'] = 'test'

require_relative '../salon'

module RSpecMixin
  include Rack::Test::Methods
  def app() Salon end
end

RSpec.configure { |c| c.include RSpecMixin }
