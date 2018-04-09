require "spec_helper"

RSpec.describe "Resource management", type: :request do
  def app() ResourceController end

  let(:access_token) { ENV['TOKEN'] || 'access_token' }
  let(:json_headers) do
    {
      "ACCEPT" => "application/json",
      "HTTP_ACCEPT" => "application/json"
    }
  end
  let(:auth_headers) do
    {
      'HTTP_AUTHORIZATION' => "Bearer #{access_token}"
    }
  end

  before(:all) do
    RedisObject.redis.flushall
  end

  after do
    RedisObject.redis.flushall
  end

  describe "create persistent link" do
    let(:link_hash){ { id: "abc", url: "http://example.com" } }
    let(:link_json){ link_hash.to_json }
    it "doesn't create a resource without authorization" do
      post "/", link_json, json_headers

      expect(last_response.content_type).to eq("application/json")
      expect(last_response.status).to eq 401

      expect(PersistentLink.new(id: "abc").get_url).to eq nil
    end

    it "creates a new resource" do
      post "/", link_json, json_headers.merge(auth_headers)

      expect(last_response.content_type).to eq("application/json")
      expect(last_response.status).to eq 201

      expect(PersistentLink.new(id: "abc").get_url).to eq "http://example.com"
    end
  end


  # it "creates a Widget and redirects to the Widget's page" do
  #   get "/widgets/new"
  #   expect(response).to render_template(:new)
  #
  #   post "/widgets", :widget => {:name => "My Widget"}
  #
  #   expect(response).to redirect_to(assigns(:widget))
  #   follow_redirect!
  #
  #   expect(response).to render_template(:show)
  #   expect(response.body).to include("Widget was successfully created.")
  # end
  #
  # it "does not render a different template" do
  #   get "/widgets/new"
  #   expect(response).to_not render_template(:show)
  # end
end
