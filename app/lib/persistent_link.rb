class PersistentLink < RedisObject
  attr_reader :id
  attr_accessor :url
  include Sinatra::IdHelper

  def initialize(id: nil, url: nil)
    @id = id
    @url = url
  end

  def id
    @id ||= generate_unique_id
  end

  def get_url
    @url ||= redis.get("#{id}")
  end

  def url
    @url
  end

  def valid?
    !!@url
  end

  def to_s
    to_json
  end

  def save(validate: true)
    return false if validate && !valid?
    redis.set(id, url)
  end

  def destroy
    redis.del(id)
  end

  def to_json
    { id: id, url: url }.to_json
  end
end
