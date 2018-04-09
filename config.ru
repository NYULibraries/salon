# config.ru
require 'sinatra/base'

# pull in the helpers and controllers
Dir.glob('./app/{helpers,controllers}/*.rb').each { |file| require file }

# map the controllers to routes
map('/')      { run ResourceController }
map('/docs')   { run DocsController } if ENV['RACK_ENV'] == 'development'
