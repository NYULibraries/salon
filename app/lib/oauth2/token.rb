require_relative 'base'

module OAuth2
  class Token < Base
    attr_accessor :access_token, :scope
    attr_accessor :status_code, :error_response

    def initialize(access_token:, scope: nil)
      @access_token = access_token
      @scope = scope
    end

    def valid?
      if scope == 'admin'
        valid_with_scope?(scope)
      else
        valid_no_scope?
      end
    rescue RestClient::Exception => e
      require 'pry';binding.pry
      set_error!(e.http_code, JSON.parse(e.http_body)["error"], JSON.parse(e.http_body)["error_description"])
      false
    end

  private

    def token_info
      @token_info ||= RestClient.get("#{self.class.oauth2_server}#{@@oauth_token_info_path}", params: { access_token: access_token })
    end

    def parsed_body
      @parsed_body ||= JSON.parse(token_info.body)
    end

    def valid_with_scope?(scope)
      valid_with_scope = parsed_body["scopes"].include?(scope)
      self.status_code = (valid_with_scope) ? token_info.code : 401 # Unauthorized
      set_error!(status_code, 'invalid_request', 'The user does not have sufficient privileges to perform this action.') if status_code == 401
      valid_with_scope
    end

    def valid_no_scope?
      token_info.code == 200 && parsed_body["scopes"].nil?
    end

    def set_error!(status_code, error, description)
      self.status_code = status_code
      self.error_response = self.set_error(error, description)
      false
    end

  end
end
