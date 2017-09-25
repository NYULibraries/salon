require_relative 'base'

module OAuth2
  class Token < Base
    attr_accessor :access_token, :scope

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
    rescue RestClient::Exception
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
      valid_no_scope? && parsed_body["scopes"].include?(scope)
    end

    def valid_no_scope?
      token_info.code == 200
    end

  end
end
