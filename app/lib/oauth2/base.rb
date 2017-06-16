require 'rest-client'

module OAuth2
  class Base

    attr_accessor :status_code, :error_response

    @@oauth_token_info_path = "/oauth/token/info"
    @@token_path = "/oauth/token"

    def self.oauth2_server
      ENV['OAUTH2_SERVER'] || 'http://dockerhost:3000'
    end

    def initialize
      raise RuntimeError, 'This is an abstract class'
    end

  protected

    def set_error(e)
      { error: { code: JSON.parse(e.http_body)["error"], description: JSON.parse(e.http_body)["error_description"] } }
    end

  end
end
