require 'rack/test'
require 'rspec'

ENV['RACK_ENV'] = 'test'

require_relative '../permalinks'

module RSpecMixin
  include Rack::Test::Methods
  def app() Permalinks end
end

RSpec.configure { |c| c.include RSpecMixin }
