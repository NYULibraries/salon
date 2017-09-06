class PersistentLink < RedisObject
  attr_reader :id, :url
  include Sinatra::IdHelper
  # include Sinatra::RedisHelper

  # set :cache,

  # def self.new_from_params(params)
  #   new(params.map{|k,v| [k.to_sym, v] }.to_h)
  # end

  def initialize(id: nil, url: nil)
    @id = id
    @url = url
  end

  def id
    @id ||= generate_unique_id
  end

  def url
    @url ||= redis.get("#{id}")
  end

  def valid?
    !!url
  end

  def save
    return false unless valid?
    redis.set(id, url)
  end

  def destroy
    redis.del(id)
  end

  def to_json
    { id: id, url: url }.to_json
  end
end
