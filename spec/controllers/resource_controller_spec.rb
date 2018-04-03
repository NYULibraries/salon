require 'spec_helper'

describe 'ResourceController' do
  def app() ResourceController end

  subject { last_response }

  let(:redis){ spy('redis', get: nil, set: nil, keys: []) }
  before { allow(RedisObject).to receive(:redis).and_return redis }

  describe "GET /" do
    before { get "/" }
    it { is_expected.to be_not_found }
  end

  describe "GET /:identifier" do
    let(:example_site) { 'https://www.example.com/' }
    before do
      allow(redis).to receive(:get).with('good_identifier').and_return example_site
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

  describe "POST /" do
    let(:access_token) { ENV['TOKEN'] || 'access_token' }
    let(:data) { nil }
    context 'when bearer token is sent in authorization header' do
      before { allow(redis).to receive(:set).and_return true }
      before { post "/", data, {'HTTP_AUTHORIZATION' => "Bearer #{access_token}"} }
      subject { last_response }

      context 'and access token is valid for admin' do
        let(:access_token) { ENV['ADMIN_TOKEN'] || 'admin_access_token' }
        let(:data) { '{"id":"key","url":"http://value.com"}' }
        its(:status) { is_expected.to eql 201 }
        its(:body) { is_expected.to eql data }
      end

      context 'and access token is valid for non-admin' do
        context 'but data is invalid' do
          its(:status) { is_expected.to eql 400 }
          its(:body) { is_expected.to include "Invalid JSON" }
        end
        context 'and data is valid' do
          let(:data) { '{"id":"key","url":"http://value.com"}' }
          its(:status) { is_expected.to eql 201 }
          its(:body) { is_expected.to eql data }
          it "should save data" do
            expect(redis).to have_received(:set).with("key", "http://value.com")
          end
        end
      end
    end
    context 'when bearer token is NOT sent' do
      before { post "/" }
      its(:status) { is_expected.to eql 401 }
      its(:body) { is_expected.to eql '{"error":"Unauthorized: The user does not have sufficient privileges to perform this action."}' }
    end
  end

  describe "POST /create_with_array" do
    # tested in dredd
  end

  describe "POST /create_empty_resource" do
    # tested in dredd
  end

  describe "POST /reset_with_array" do
    let(:data) { nil }
    let(:access_token) { ENV['TOKEN'] || 'access_token' }
    context 'when bearer token is sent in authorization header' do
      before { post "/reset_with_array", data, {'HTTP_AUTHORIZATION' => "Bearer #{access_token}"} }
      subject { last_response }

      context 'and access token is valid for non-admin' do
        its(:status) { is_expected.to eql 401 }
      end
      context 'and access token is valid for admin' do
        let(:access_token) { ENV['ADMIN_TOKEN'] || 'admin_access_token' }
        context 'but data is invalid' do
          its(:status) { is_expected.to eql 400 }
          its(:body) { is_expected.to include "Invalid JSON"}
        end
        context 'and data is valid' do
          let(:data) { '[{"id":"key","url":"http://value.com"},{"id":"key2","url":"http://value2.org"}]' }
          its(:status) { is_expected.to eql 201 }
          its(:body) { is_expected.to eql data }
          it "should save data" do
            expect(redis).to have_received(:set).with("key", "http://value.com").ordered
            expect(redis).to have_received(:set).with("key2", "http://value2.org").ordered
            expect(redis).to_not have_received(:del)
          end
        end
      end
    end
    context 'when bearer token is NOT sent' do
      before { post "/" }
      its(:status) { is_expected.to eql 401 }
      its(:body) { is_expected.to eql '{"error":"Unauthorized: The user does not have sufficient privileges to perform this action."}' }
    end
  end
end
