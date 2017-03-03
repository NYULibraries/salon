require 'sinatra/base'
require 'redis-sinatra'

class Permalinks < Sinatra::Base
  set :cache, Sinatra::Cache::RedisStore.new("#{ENV.fetch('REDIS_HOST','localhost')}:#{ENV.fetch('REDIS_PORT','6379')}")

  get '/:identifier' do
    redirect_url = settings.cache.fetch("#{params['identifier']}")
    redirect to(redirect_url) if redirect_url
    status 400
  end

  not_found do
    status 404
  end
end
