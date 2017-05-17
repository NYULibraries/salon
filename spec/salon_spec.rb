require_relative 'spec_helper'

describe 'Salon' do
  let(:example_site) { 'https://www.example.com/' }
  before(:each) do
    cache = double('cache', :get => nil)
    allow(cache).to receive(:get).with('good_identifier') { example_site }
    allow(Salon.settings).to receive(:cache) {cache}
    get identifier
  end

  context 'if no identifier is passed in' do
    let(:identifier) {'/'}
    it 'it should not allow accessing the page' do
      expect(last_response).to be_not_found
    end
  end
  context 'if an identifier is passed in' do
    context 'and the identifier is a key in the cache' do
      let(:identifier) {'/good_identifier'}
      it 'should be a redirect to the cache value' do
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.url).to eql example_site
      end
    end
    context 'and the identifier is not a key in the cache' do
      let(:identifier) {'/bad_identifier'}
      it 'should be a bad request' do
        expect(last_response).to be_bad_request
      end
    end
  end
end
