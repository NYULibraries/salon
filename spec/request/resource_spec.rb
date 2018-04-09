require "spec_helper"

RSpec.describe "Resource management", type: :request do
  def app() ResourceController end

  subject { last_response }

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

    context "without authorization" do
      before { post "/", link_json, json_headers }

      its(:status) { is_expected.to eq 401 }
      it "should not create new link" do
        expect(PersistentLink.new(id: "abc").get_url).to eq nil
      end
    end

    context "with authorization" do
      before { post "/", link_json, json_headers.merge(auth_headers) }

      its(:status) { is_expected.to eq 201 }
      it "should create new link" do
        expect(PersistentLink.new(id: "abc").get_url).to eq "http://example.com"
      end
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
