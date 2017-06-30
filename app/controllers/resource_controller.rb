require_relative 'application_controller'
require_relative '../lib/oauth2/token'
require_relative '../helpers/json_to_redis_helpers'

class ResourceController < ApplicationController
  helpers Sinatra::RedisHelper
  helpers Sinatra::JsonHelper
  helpers Sinatra::JsonToRedisHelper
  helpers Sinatra::IdHelper

  before do
    session[:access_token] = env.fetch('HTTP_AUTHORIZATION', '').slice(7..-1)
  end

  before /^(?!\/reset_with_array)/ do
    next unless request.post?
    authenticate!
  end

  before '/reset_with_array' do
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
    if !json_params['url']
      status 422
      return {error: "Invalid resource: 'url' required"}.to_json
    end
    id = json_params['id'] || generate_unique_id
    redis.set(id, json_params['url'])
    status 201
    {id: id, url: json_params['url']}.to_json
  end

  post '/create_with_array' do
    if json_params.any?{|resource| !resource['url'] }
      status 422
      return {error: "Invalid resource: 'url' required for all resources"}.to_json
    end
    response_array = json_params.map do |resource|
      id = resource['id'] || generate_unique_id
      redis.set(id, resource['url'])
      {id: id, url: resource['url']}
    end
    status 201
    response_array.to_json
  end

  post '/create_empty_resource' do
    generate_unique_id.to_json
  end

  post '/reset_with_array' do
    if json_params.any?{|resource| !resource['url'] }
      status 422
      return {error: "Invalid resource: 'url' required for all resources"}.to_json
    end
    response_array = json_params.map do |resource|
      id = resource['id'] || generate_unique_id
      redis.set(id, resource['url'])
      {id: id, url: resource['url']}
    end
    omitted_stored_params.each do |key|
      redis.del key
    end
    status 201
    response_array.to_json
  end

  def authenticate!(admin: false)
    token = OAuth2::Token.new(access_token: session[:access_token])
    token.scope = 'admin' if admin

    unless token.valid?
      halt 401, { error: "Unauthorized: The user does not have sufficient privileges to perform this action." }.to_json
    end
  end

end
