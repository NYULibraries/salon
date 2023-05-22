require_relative 'application_controller'
require_relative '../lib/oauth2/token'
require_relative '../helpers/json_to_redis_helpers'

class ResourceController < ApplicationController
  helpers Sinatra::JsonHelper
  helpers Sinatra::JsonToRedisHelper
  helpers Sinatra::IdHelper
  helpers Sinatra::LinkHelper

  before do
    session[:access_token] = env.fetch('HTTP_AUTHORIZATION', '').slice(7..-1)
  end

  before do
    next unless request.post?
    if request.path_info == '/reset_with_array'
      authenticate!(admin: true)
    else
      authenticate!
    end
  end

  get '/healthcheck' do
    content_type :json
    return {success: true}.to_json
  end

  get '/:identifier' do
    link = PersistentLink.new(id: "#{params['identifier']}")
    redirect to(link.url) if link.get_url && link.get_url != ''
    status 400
    erb :bad_request
  end

  post '/' do
    link = new_link(json_params)
    if link.save
      status 201
      link.to_json
    else
      status 422
      return {error: "Invalid resource: 'url' required"}.to_json
    end
  end

  post '/create_with_array' do
    if !json_params.is_a?(Array)
      status 422
      return {error: "Invalid resource: must be array"}.to_json
    end
    if link_collection.save_all
      status 201
      link_collection.to_json
    else
      status 422
      return {error: "Invalid resource: 'url' required"}.to_json
    end
  end

  post '/create_empty_resource' do
    link = PersistentLink.new
    link.save(validate: false)
    link.id.to_json
  end

  post '/reset_with_array' do
    if link_collection.save_all
      omitted_stored_links.each do |link|
        link.url = ""
        link.save
      end
      status 201
      link_collection.to_json
    else
      status 422
      return {error: "Invalid resource: 'url' required for all resources"}.to_json
    end
  end

  def authenticate!(admin: false)
    token = OAuth2::Token.new(access_token: session[:access_token])
    token.scope = 'admin' if admin

    unless token.valid?
      halt 401, { error: "Unauthorized: The user does not have sufficient privileges to perform this action." }.to_json
    end
  end

end
