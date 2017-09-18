require 'sinatra/base'
require_relative 'json_helpers'

module Sinatra
  module JsonToRedisHelper
    def omitted_stored_params
      settings.cache.keys - json_params.map{|resource| resource['id'] }
    end
  end

  helpers JsonToRedisHelper
end
