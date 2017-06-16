require_relative 'base'

module OAuth2
  class Token < Base
    attr_accessor :access_token, :scope

    def initialize(access_token:, scope: nil)
      @access_token = access_token
      @scope = scope
    end

    def valid?
      require 'pry';binding.pry
      @status_code = token_info.code
      parsed_body = JSON.parse(token_info.body)
      status_code == 200
    rescue RestClient::Exception => e
      @status_code = e.http_code
      @error_response = self.set_error(e)
      false
    end

  private

    def token_info
      token_info = RestClient.get("#{self.class.oauth2_server}#{@@oauth_token_info_path}", params: options)
    end

    def options(default_options = { access_token: access_token })
      default_options.merge!(scope: scope) unless scope.nil?
      default_options
    end

  end
end
