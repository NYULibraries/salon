require_relative 'application_controller'
require 'yaml'

class DocsController < ApplicationController

  get '/v1/docs' do
    erb :swagger_redoc
  end

  get '/v1/swagger.json' do
    YAML.load(File.open("#{File.expand_path('../../..', __FILE__)}/swagger.yml"){|f| f.read }).to_json
  end

end
