require "spec_helper"

RSpec.describe "Resource management", type: :request do
  def app() ResourceController end

  subject { last_response }
  let(:json_response){ JSON.parse(subject.body) }

  let(:json_headers) do
    {
      "ACCEPT" => "application/json",
      "HTTP_ACCEPT" => "application/json"
    }
  end

  before(:all) do
    RedisObject.redis.flushall
  end

  after do
    RedisObject.redis.flushall
  end

  describe "using Basic auth" do
    let(:basic_token) { 'lesssecret' }
    let(:basic_admin_token) { 'supersecret' }
    let(:auth_headers) do
      {
        'HTTP_AUTHORIZATION' => "Basic #{basic_token}"
      }
    end
    describe "create persistent link" do
      let(:link_hash){ { id: "abc", url: "http://example.com" } }
      let(:link_json){ link_hash.to_json }

      context "without authorization" do
        before { post "/", link_json, json_headers }

        its(:status) { is_expected.to eq 401 }
        it "should not create new link" do
          expect(RedisObject.redis.keys).to be_empty
        end
      end

      context "with authorization" do
        before { post "/", link_json, json_headers.merge(auth_headers) }

        context "with valid, full link" do
          its(:status) { is_expected.to eq 201 }
          it "should create new link" do
            expect(PersistentLink.new(id: "abc").get_url).to eq "http://example.com"
          end
        end

        context "with valid link with only URL" do
          let(:link_hash){ {url: "http://example.com"} }

          its(:status) { is_expected.to eq 201 }
          it "should create new link" do
            id = json_response["id"]
            expect(PersistentLink.new(id: id).get_url).to eq "http://example.com"
          end
        end

        context "with invalid link with only ID" do
          let(:link_hash){ {id: "abc"} }

          its(:status) { is_expected.to eq 422 }
          it "should not create new link" do
            expect(RedisObject.redis.keys).to be_empty
          end
        end
      end
    end

    describe "create persistent links" do
      let(:links_hash){ [{id: "abc", url: "http://example.com"}, {id: "123", url: "https://example.org"}] }
      let(:links_json){ links_hash.to_json }

      context "without authorization" do
        before { post "/create_with_array", links_json, json_headers }

        its(:status) { is_expected.to eq 401 }
        it "should not create new link" do
          expect(RedisObject.redis.keys).to be_empty
        end
      end

      context "with authorization" do
        before { post "/create_with_array", links_json, json_headers.merge(auth_headers) }

        context "with valid, full links" do
          its(:status) { is_expected.to eq 201 }
          it "should create new links" do
            expect(PersistentLink.new(id: "abc").get_url).to eq "http://example.com"
            expect(PersistentLink.new(id: "123").get_url).to eq "https://example.org"
          end
        end

        context "with valid link with only URLs" do
          let(:links_hash){ [{url: "http://example.com"}, {url: "https://example.org"}] }

          its(:status) { is_expected.to eq 201 }
          it "should create new link" do
            id_for_com = json_response.detect{|x| x["url"] == "http://example.com"}["id"]
            expect(PersistentLink.new(id: id_for_com).get_url).to eq "http://example.com"

            id_for_org = json_response.detect{|x| x["url"] == "https://example.org"}["id"]
            expect(PersistentLink.new(id: id_for_org).get_url).to eq "https://example.org"
          end
        end

        context "with invalid link with only ID" do
          let(:links_hash){ [{id: "abc"}, {id: "123"}] }

          its(:status) { is_expected.to eq 422 }
          it "should not create new link" do
            expect(RedisObject.redis.keys).to be_empty
          end
        end
      end
    end

    describe "create empty resource" do
      context "without authorization" do
        before { post "/create_empty_resource", "", json_headers }

        its(:status) { is_expected.to eq 401 }
        it "should not create new link" do
          expect(RedisObject.redis.keys).to be_empty
        end
      end

      context "with authorization" do
        before { post "/create_empty_resource", "", json_headers.merge(auth_headers) }

        its(:status) { is_expected.to eq 200 }
        it "should create new link" do
          id = json_response
          expect(PersistentLink.new(id: id).get_url).to eq ""
        end
      end
    end

    describe "create persistent links" do
      let(:links_hash){ [{id: "abc", url: "http://example.com"}, {id: "123", url: "https://example.org"}] }
      let(:links_json){ links_hash.to_json }

      let(:existing_link){ PersistentLink.new(id: "existing", url: "http://library.nyu.edu") }
      before{ existing_link.save }

      context "without authorization" do
        before { post "/reset_with_array", links_json, json_headers }

        its(:status) { is_expected.to eq 401 }
        it "should not create new link" do
          expect(RedisObject.redis.keys).to match_array ["existing"]
        end
        it "should preserve existing link" do
          expect(existing_link.get_url).to eq "http://library.nyu.edu"
        end
      end

      context "with non-admin authorization" do
        before { post "/reset_with_array", links_json, json_headers.merge(auth_headers) }

        its(:status) { is_expected.to eq 401 }
        it "should not create new link" do
          expect(RedisObject.redis.keys).to match_array ["existing"]
        end
        it "should preserve existing link" do
          expect(existing_link.get_url).to eq "http://library.nyu.edu"
        end
      end

      context "with admin authorization" do
        let(:basic_token){ basic_admin_token }

        before { post "/reset_with_array", links_json, json_headers.merge(auth_headers) }

        context "with valid, full links" do
          its(:status) { is_expected.to eq 201 }
          it "should create new links" do
            expect(PersistentLink.new(id: "abc").get_url).to eq "http://example.com"
            expect(PersistentLink.new(id: "123").get_url).to eq "https://example.org"
          end
          it "should set existing link to blank strink" do
            expect(existing_link.get_url).to eq ""
          end
        end

        context "with valid link with only URLs" do
          let(:links_hash){ [{url: "http://example.com"}, {url: "https://example.org"}] }

          its(:status) { is_expected.to eq 201 }
          it "should create new link" do
            id_for_com = json_response.detect{|x| x["url"] == "http://example.com"}["id"]
            expect(PersistentLink.new(id: id_for_com).get_url).to eq "http://example.com"

            id_for_org = json_response.detect{|x| x["url"] == "https://example.org"}["id"]
            expect(PersistentLink.new(id: id_for_org).get_url).to eq "https://example.org"
          end
          it "should set existing link to blank strink" do
            expect(existing_link.get_url).to eq ""
          end
        end

        context "with invalid link with only ID" do
          let(:links_hash){ [{id: "abc"}, {id: "123"}] }

          its(:status) { is_expected.to eq 422 }
          it "should not create new link" do
            expect(RedisObject.redis.keys).to match_array ["existing"]
          end
          it "should preserve existing link" do
            expect(existing_link.get_url).to eq "http://library.nyu.edu"
          end
        end
      end
    end
  end
end
