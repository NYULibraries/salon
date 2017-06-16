require_relative 'application_controller'
require_relative '../lib/oauth2/token'
require_relative '../helpers/json_to_redis_helpers'

class ResourceController < ApplicationController
  helpers Sinatra::RedisHelper
  helpers Sinatra::JsonHelper
  helpers Sinatra::JsonToRedisHelper

  before do
    session[:access_token] = env.fetch('HTTP_AUTHORIZATION', '').slice(7..-1)
  end

  before /^(?!\/reset)/ do
    next unless request.post?
    token = OAuth2::Token.new(access_token: session[:access_token])

    unless token.valid?
      halt token.status_code, token.error_response.to_json
    end
  end

  before '/reset' do
    next unless request.post?
    token = OAuth2::Token.new(access_token: session[:access_token], scope: 'admin')
    # require 'pry';binding.pry
    unless token.valid?
      halt token.status_code, token.error_response.to_json
    end
  end

  get '/:identifier' do
    redirect_url = redis.get("#{params['identifier']}")
    redirect to(redirect_url) if redirect_url
    status 400
    erb :bad_request
  end

  post '/' do
    export_json_to_redis
    {success: true}.to_json
  end

  post '/reset' do
    export_json_to_redis
    omitted_stored_params.each do |key|
      redis.del key
    end
    {success: true}.to_json
  end

end
