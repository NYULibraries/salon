require 'sinatra/base'
require 'redis-store'

module Sinatra
  module RedisHelper
    def redis
      settings.cache
    end
  end

  helpers RedisHelper
end
