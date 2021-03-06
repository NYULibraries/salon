# config.ru
require 'rack'
require 'sinatra/base'
require_relative 'config/metrics'
require 'raven'

# require 'ddtrace'

# Datadog.configure do |c|
#   c.use :sinatra, service_name: 'Salon'
#   c.tracer enabled: ((ENV['RACK_ENV'] == 'production') ? true : false), 
#            env: ENV['RACK_ENV'],
#            tags: { 'env' => ENV['RACK_ENV'], 'app' => 'salon', 'framework' => 'sinatra' }
# end

# pull in the helpers and controllers
Dir.glob('./app/{helpers,controllers}/*.rb').each { |file| require file }

# map the controllers to routes
#map('/')      { run ResourceController }
run ResourceController
map('/docs')   { run DocsController } if ENV['RACK_ENV'] == 'development' || ENV['RACK_ENV'] == 'test'

Raven.configure do |config|
  config.server = ENV['SENTRY_DSN']
end

use Rack::Deflater
# Run prometheus middleware to collect default metrics
use Prometheus::Middleware::CollectorWithExclusions
# Run prometheus exporter to have a /metrics endpoint that can be scraped
# The endpoint will only be available to prometheus
use Prometheus::Middleware::Exporter
use Raven::Rack
