require 'rest-client'

module OAuth2
  class Base

    @@oauth_token_info_path = "/oauth/token/info"

    def self.oauth2_server
      ENV['OAUTH2_SERVER'] || 'http://192.168.99.100:3000'
    end

    def initialize
      raise RuntimeError, 'This is an abstract class'
    end

  protected

    def set_error(error, error_description)
      { error: { code: error, description: error_description } }
    end

  end
end
