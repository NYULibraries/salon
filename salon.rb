require 'sinatra/base'
require 'redis-store'
require 'json'

class Salon < Sinatra::Base
  set :cache, Redis::Store::Factory.create("#{ENV.fetch('REDIS_ADDRESS','localhost:6379')}", { marshalling: false })

  before do
    content_type :json
    next unless request.post?
    halt 401 unless request.env["HTTP_AUTH"].eql?(ENV['TEST_AUTH'])
  end

  get '/:identifier' do
    redirect_url = redis.get("#{params['identifier']}")
    redirect to(redirect_url) if redirect_url
    status 400
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

  not_found do
    erb :not_found
  end

  error 400 do
    erb :bad_request
  end

  helpers do
    def redis
      settings.cache
    end

    def json_params
      begin
        @json_params ||= JSON.parse(request.body.read)
      rescue JSON::ParserError => e
        halt 400, { message: "Invalid JSON #{e.message}" }.to_json #"{\"message\":\"Invalid JSON: #{e.message}\"}" #
      end
    end

    def export_json_to_redis
      json_params.each do |key, url|
        redis.set key, url
      end
    end

    def omitted_stored_params
      settings.cache.keys - json_params.keys
    end
  end
end
