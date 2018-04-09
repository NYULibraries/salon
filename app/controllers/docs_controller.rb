require_relative 'application_controller'
require 'yaml'

# Only for dev use, in production this should be handled by ghpages
# nyulibraries.github.io/salon
class DocsController < ApplicationController

  get '/' do
    erb :swagger_redoc
  end

  get '/swagger.json' do
    send_file(File.join(File.expand_path('../../../docs', __FILE__), 'swagger.json'))
  end

end
