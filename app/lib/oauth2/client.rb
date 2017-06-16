require_relative 'base'

module OAuth2
  class Client < Base
    attr_accessor :client_id, :client_secret, :scope

    def initialize(client_id:, client_secret:, scope: nil)
      @client_id = client_id
      @client_secret = client_secret
      @scope = scope
    end

    def get_token
      @status_code = create_token.code
      JSON.parse(create_token.body)
    rescue RestClient::Exception => e
      @status_code = e.http_code
      @error_response = self.set_error(e)
    end

   private

    def create_token
      @create_token ||= RestClient.post("#{self.class.oauth2_server}#{@@token_path}", {
        grant_type: 'client_credentials',
        client_id: client_id,
        client_secret: client_secret,
        scope: scope
      })
    end

  end
end
