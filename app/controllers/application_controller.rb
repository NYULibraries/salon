require 'sinatra/base'
require 'redis-store'
require_relative '../lib/redis_object'
require_relative '../lib/persistent_link'
require_relative '../lib/persistent_link_collection'

class ApplicationController < Sinatra::Base
  enable :sessions

  before do
    next unless request.post?
    content_type :json
  end

  not_found do
    erb :not_found
  end

end
