class PersistentLinkCollection < RedisObject
  include Enumerable
  extend Forwardable
  delegate [:each, :all?, :[], :map, :empty?, :length] => :@members

  def self.all
    new(stored_keys.map{|key| PersistentLink.new(id: key) })
  end

  def self.stored_keys
    redis.keys
  end

  def initialize(members = [])
    @members = members
  end

  def save_all
    return false unless all?(&:valid?)
    each(&:save)
  end

  def to_s
    "[#{map(&:to_s).join(',')}]"
  end

  def destroy_all
    each(&:destroy)
  end

  def -(other_collection)
    other_collection_ids = other_collection.map(&:id)
    self.class.new(@members.select{|link| !other_collection_ids.include?(link.id) })
  end

  def to_json
    map{|link| { id: link.id, url: link.url } }.to_json
  end
end
