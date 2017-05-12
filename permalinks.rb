require 'sinatra/base'
require 'redis-store'

class Permalinks < Sinatra::Base
  set :cache, Redis::Store::Factory.create("#{ENV.fetch('REDIS_ADDRESS','localhost:6379')}", { marshalling: false })

  get '/:identifier' do
    redirect_url = settings.cache.get("#{params['identifier']}")
    redirect to(redirect_url) if redirect_url
    status 400
  end

  not_found do
    send_file(File.join(File.dirname(__FILE__), 'public', '404.html'), { status: 404 })
  end
end
