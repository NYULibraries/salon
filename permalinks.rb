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
    send_file(File.join(File.dirname(__FILE__), 'public', '404.html'), { status: 404 })
  end

  # bad_request do
  #   send_file(File.join(File.dirname(__FILE__), 'public', '400.html'), { status: 400 })
  # end
end
