require 'sinatra/base'
require 'json'

module Sinatra
  module LinkHelper
    def new_link(params)
      PersistentLink.new(id: params['id'], url: params['url'])
    end

    def link_collection
      @link_collection ||= PersistentLinkCollection.new(link_array)
    end

    def link_array
      return @link_array if @link_array
      @link_array = json_params.map do |link_attrs|
        PersistentLink.new(id: link_attrs['id'], url: link_attrs['url'])
      end
    end

    def omitted_stored_links
      @omitted_stored_links ||= PersistentLinkCollection.all - link_collection
    end
  end

  helpers LinkHelper
end
