require 'sinatra/base'
require 'redis-store'
require 'json'

class Permalinks < Sinatra::Base
  set :cache, Redis::Store::Factory.create("#{ENV.fetch('REDIS_ADDRESS','localhost:6379')}", { marshalling: false })

  before do
    next unless request.post?
    halt 401 unless request.env["HTTP_AUTH"].eql?(ENV['TEST_AUTH'])
  end

  get '/:identifier' do
    redirect_url = settings.cache.get("#{params['identifier']}")
    redirect to(redirect_url) if redirect_url
    status 400
  end

  post '/' do
    parsed_json = JSON.parse(request.body.read)
    parsed_json.keys.each do |key|
      settings.cache.set(key, parsed_json[key])
    end
    status 200
  end

  not_found do
    erb :not_found
  end

  error 400 do
    erb :bad_request
  end
end
