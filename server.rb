require 'sinatra/base'
require 'redis-sinatra'

ENV['redis_host'] = 'localhost'
ENV['redis_port'] = '6379'

@@redis = Sinatra::Cache::RedisStore.new("#{ENV['redis_host']}:#{ENV['redis_port']}")
@@redis.write("nyu", "https://www.nyu.edu")

class Permalinks < Sinatra::Base
  set :cache, @@redis

  get '/:identifier' do
    redirect_url = settings.cache.fetch("#{params['identifier']}")
    redirect to(redirect_url) if redirect_url
    status 400
  end

  not_found do
    status 404
  end
end
