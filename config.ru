# config.ru
require 'sinatra/base'
require 'raven'

# pull in the helpers and controllers
Dir.glob('./app/{helpers,controllers}/*.rb').each { |file| require file }

# map the controllers to routes
#map('/')      { run ResourceController }
run ResourceController 
map('/docs')   { run DocsController } if ENV['RACK_ENV'] == 'development' || ENV['RACK_ENV'] == 'test'

Raven.configure do |config|
  config.server = ENV['SENTRY_DSN']
end

use Raven::Rack
