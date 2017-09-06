require 'sinatra/base'
require 'redis-store'
require_relative '../../lib/redis_object'
require_relative '../../lib/persistent_link'
require_relative '../../lib/persistent_link_collection'

class ApplicationController < Sinatra::Base
  enable :sessions


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
