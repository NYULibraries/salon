require 'spec_helper'

describe 'DocsController' do
  def app() DocsController end

  subject { last_response }

  describe "GET /v1/docs" do
    before { get "/v1/docs" }
    it { is_expected.to be_ok }
  end

  describe "GET /v1/swagger.json" do
    let(:hash){ { version: "1", something: "else" } }
    let(:yaml){ hash.to_yaml }
    let(:json){ hash.to_json }
    before do
      allow(File).to receive(:open).and_return yaml
      get "/v1/swagger.json"
    end
    it { is_expected.to be_ok }
    its(:body) { is_expected.to eq json }
  end
end
