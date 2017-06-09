require 'sinatra/base'
require 'redis-store'
require 'json'
require 'yaml'

class Salon < Sinatra::Base
  set :cache, Redis::Store::Factory.create("#{ENV.fetch('REDIS_HOST','localhost:6379')}", { marshalling: false })

  before do
    next unless request.post?
    content_type :json
    unless request.env["HTTP_AUTH"] && request.env["HTTP_AUTH"].eql?(ENV['TEST_AUTH'])
      halt 401, {error: "Auth header not found or invalid"}.to_json
    end
  end

  get '/api/v1/docs' do
    erb :swagger_redoc
  end

  get '/api/v1/swagger.json' do
    YAML.load(File.open('swagger.yml'){|f| f.read }).to_json
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

  not_found do
    send_file(File.join(File.dirname(__FILE__), 'public', '40x.html'), { status: 404 })
  end

  helpers do
    def redis
      settings.cache
    end

    def json_params
      begin
        @json_params ||= JSON.parse(request.body.read)
      rescue JSON::ParserError => e
        halt 400, { error: "Invalid JSON #{e.message}" }.to_json #"{\"message\":\"Invalid JSON: #{e.message}\"}" #
      end
    end

    def generate_unique_id
      loop do
        id = generate_random_id
        return id unless redis.get id
      end
    end

    def generate_random_id
      SecureRandom.hex(4)
    end

    def omitted_stored_params
      settings.cache.keys - json_params.map{|resource| resource['id'] }
    end
  end
end
