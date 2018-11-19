# config.ru
require 'rack'
require 'sinatra/base'
require 'prometheus/middleware/collector'
require 'prometheus/middleware/exporter'
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

use Rack::Deflater
# Run prometheus middleware to collect default metrics
use Prometheus::Middleware::Collector, metrics_prefix: ENV['PROMETHEUS_METRICS_PREFIX'], counter_label_builder: -> (env, code) {
  {
    code:         code,
    method:       env['REQUEST_METHOD'].downcase,
    host:         env['HTTP_HOST'].to_s,
    path:         env['PATH_INFO'],
    querystring:  env['QUERY_STRING']
  }
}, duration_label_builder: -> (env, code)
  {
    code:         code,
    method:       env['REQUEST_METHOD'].downcase,
    host:         env['HTTP_HOST'].to_s,
    path:         env['PATH_INFO'],
    querystring:  env['QUERY_STRING']
  }
}
# Run prometheus exporter to have a /metrics endpoint that can be scraped
# The endpoint will only be available to prometheus
use Prometheus::Middleware::Exporter

use Raven::Rack
