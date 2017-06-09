require 'sinatra/base'
require 'json'

module Sinatra
  module JsonHelper
    def json_params
      begin
        @json_params ||= JSON.parse(request.body.read)
      rescue JSON::ParserError => e
        halt 400, { error: "Invalid JSON #{e.message}" }.to_json #"{\"message\":\"Invalid JSON: #{e.message}\"}" #
      end
    end

    def export_json_to_redis
      json_params.each do |key, url|
        redis.set key, url
      end
    end
  end

  helpers JsonHelper
end
