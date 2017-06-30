require 'sinatra/base'
require 'redis-store'

class ApplicationController < Sinatra::Base
  enable :sessions

  set :cache, Redis::Store::Factory.create("#{ENV.fetch('REDIS_HOST','localhost:6379')}", { marshalling: false })
  set :root, File.expand_path('../..', __FILE__)
  set :public_folder, File.expand_path('../../../public', __FILE__)

  before do
    next unless request.post?
    content_type :json
  end

  not_found do
    send_file(File.join(settings.public_folder, '40x.html'), { status: 404 })
  end

end
