require_relative 'spec_helper'

describe 'Salon' do
  subject { last_response }

  let(:cache){ double('cache', get: nil) }
  before { allow(Salon.settings).to receive(:cache).and_return cache }

  describe "GET /" do
    before { get "/" }
    it { is_expected.to be_not_found }
  end

  describe "GET /:identifier" do
    let(:example_site) { 'https://www.example.com/' }
    before do
      allow(cache).to receive(:get).with('good_identifier').and_return example_site
      get "/#{identifier}"
    end
    context 'if an identifier is passed in' do
      context 'and the identifier is a key in the cache' do
        let(:identifier) {'good_identifier'}
        it 'should be a redirect to the cache value' do
          expect(last_response).to be_redirect
          follow_redirect!
          expect(last_request.url).to eql example_site
        end
      end
      context 'and the identifier is not a key in the cache' do
        let(:identifier) {'bad_identifier'}
        it { is_expected.to be_bad_request }
      end
    end
  end

  describe "GET /api/v1/docs" do
    before { get "/api/v1/docs" }
    it { is_expected.to be_ok }
  end

  describe "GET /api/v1/swagger.json" do
    let(:hash){ {version: "1", something: "else"} }
    let(:yaml){ hash.to_yaml }
    let(:json){ hash.to_json }
    before do
      allow(File).to receive(:open).with('swagger.yml').and_return yaml
      get "/api/v1/swagger.json"
    end
    it { is_expected.to be_ok }
    its(:body) { is_expected.to eq json }
  end

  describe "POST /" do
    # tested in dredd via swagger
  end

  describe "POST /reset" do
    # tested in dredd via swagger
  end
end
