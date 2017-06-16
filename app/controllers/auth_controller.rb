require_relative 'application_controller'
require_relative '../lib/oauth2/client'

class AuthController < ApplicationController

  post '/get_token' do
    client = OAuth2::Client.new(client_id: params[:client_id], client_secret: params[:client_secret], scope: params[:scope])
    response = client.get_token
    status client.status_code unless client.status_code.nil?
    response.to_json
  end

end
