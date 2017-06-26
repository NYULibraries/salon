require 'rest-client'

module OAuth2
  class Base

    @@oauth_token_info_path = "/oauth/token/info"

    def self.oauth2_server
      ENV['OAUTH2_SERVER'] || 'https://dev.login.library.nyu.edu'
    end

    def initialize
      raise RuntimeError, 'This is an abstract class'
    end

  end
end
