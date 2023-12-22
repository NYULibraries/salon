require 'sinatra/base'
require 'json'

module Sinatra
  module JsonHelper
    def json_params
      begin
        body = request.body.read
        @json_params ||= JSON.parse(body)
      rescue JSON::ParserError => e
        puts "Invalid json: #{e.message} --- body: #{body}"
        halt 400, { error: "Invalid JSON #{e.message}" }.to_json
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
