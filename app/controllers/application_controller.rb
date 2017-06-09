require 'sinatra/base'
require 'redis-store'

class ApplicationController < Sinatra::Base
  set :cache, Redis::Store::Factory.create("#{ENV.fetch('REDIS_HOST','localhost:6379')}", { marshalling: false })
  set :root, File.expand_path('../..', __FILE__)
  set :public_folder, File.expand_path('../../../public', __FILE__)

  before do
    next unless request.post?
    content_type :json
    unless request.env["HTTP_AUTH"] && request.env["HTTP_AUTH"].eql?(ENV['TEST_AUTH'])
      halt 401, {error: "Auth header not found or invalid"}.to_json
    end
  end

  not_found do
    send_file(File.join(settings.public_folder, '40x.html'), { status: 404 })
  end
end
