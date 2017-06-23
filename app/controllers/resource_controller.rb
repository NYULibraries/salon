require_relative 'application_controller'
require_relative '../helpers/json_to_redis_helpers'

class ResourceController < ApplicationController
  helpers Sinatra::RedisHelper
  helpers Sinatra::JsonHelper
  helpers Sinatra::JsonToRedisHelper

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
