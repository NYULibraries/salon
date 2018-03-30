require 'spec_helper'

describe PersistentLinkCollection do
  describe "instance methods" do
    let(:collection){ described_class.new }

    describe "-" do
      subject { collection - collection2 }
      let(:collection2){ described_class.new [link1, link2] }
      let(:link1){ PersistentLink.new id: "123", url: "http://example.com" }
      let(:link2){ PersistentLink.new id: "abc", url: "http://example.org" }

      context "when collection is empty" do
        it { is_expected.to be_a described_class }
        it { is_expected.to be_empty }
        it { is_expected.to_not eq collection }
      end

      context "when collection has some elements of argument collection" do
        let(:collection){ described_class.new [link1, link3] }
        let(:link3){ PersistentLink.new id: "456", url: "http://example.com" }

        it { is_expected.to be_a described_class }
        it { is_expected.to match_array [link3] }
        # it { is_expected.to_not include link1 }
        its(:length){ is_expected.to eq 1 }
      end

      context "when collection has only elements of argument collection" do
        let(:collection){ described_class.new [link2] }

        it { is_expected.to be_a described_class }
        it { is_expected.to be_empty }
        it { is_expected.to_not eq collection }
      end
    end
  end
end
