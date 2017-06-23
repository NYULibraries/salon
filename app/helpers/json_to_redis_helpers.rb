require 'sinatra/base'
require_relative 'json_helpers'
require_relative 'redis_helpers'

module Sinatra
  module JsonToRedisHelper
    def omitted_stored_params
      settings.cache.keys - json_params.keys
    end
  end

  helpers JsonToRedisHelper
end
