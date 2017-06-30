require 'sinatra/base'
require 'json'

module Sinatra
  module IdHelper
    def generate_unique_id
      loop do
        id = generate_random_id
        return id unless redis.get id
      end
    end

    def generate_random_id
      SecureRandom.hex(4)
    end
  end

  helpers IdHelper
end
