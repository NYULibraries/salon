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
    authenticate!
  end

  before '/reset' do
    next unless request.post?
    authenticate!(admin: true)
  end

  get '/:identifier' do
    redirect_url = redis.get("#{params['identifier']}")
    redirect to(redirect_url) if redirect_url
    status 400
    erb :bad_request
  end

  post '/' do
    export_json_to_redis
    { success: true }.to_json
  end

  post '/reset' do
    export_json_to_redis
    omitted_stored_params.each do |key|
      redis.del key
    end
    { success: true }.to_json
  end

  def authenticate!(admin: false)
    token = OAuth2::Token.new(access_token: session[:access_token])
    token.scope = 'admin' if admin

    unless token.valid?
      halt 401, { error: "Unauthorized: The user does not have sufficient privileges to perform this action." }.to_json
    end
  end

end
