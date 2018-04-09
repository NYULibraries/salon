require 'spec_helper'

describe 'DocsController' do
  def app() DocsController end

  subject { last_response }

  describe "GET /" do
    before { get "/" }
    it { is_expected.to be_ok }
  end

  describe "GET /swagger.json" do
    before { get "/swagger.json" }
    it { is_expected.to be_ok }
    its(:body) { is_expected.to include '"swagger":"2.0"' }
  end
end
