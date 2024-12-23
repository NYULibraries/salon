module BasicAuth
  class Token
    attr_accessor :basic_token, :scope

    def initialize(basic_token:, scope: nil)
      @basic_token = basic_token
      @scope = scope
    end

    def valid?
      if scope == 'admin'
        valid_as_admin?
      else
        valid_non_admin?
      end
    end

  private

    def valid_as_admin?
      secure_is_equal?(basic_token, admin_token)
    rescue RuntimeError => e
      puts "Rescued error: #{e.inspect}"
      false
    end

    def admin_token
      ENV.fetch('SALON_ADMIN_BASIC_AUTH_TOKEN'){ raise 'Must set SALON_ADMIN_BASIC_AUTH_TOKEN' } 
    end

    def valid_non_admin?
      secure_is_equal?(basic_token, non_admin_token) || valid_as_admin?
    rescue RuntimeError => e
      puts "Rescued error: #{e.inspect}"
      false
    end

    def non_admin_token
      ENV.fetch('SALON_BASIC_AUTH_TOKEN'){ raise 'Must set SALON_BASIC_AUTH_TOKEN' } 
    end

    def secure_is_equal?(token1, token2)
      Digest::SHA256.digest(token1) == Digest::SHA256.digest(token2)
    end

  end
end
