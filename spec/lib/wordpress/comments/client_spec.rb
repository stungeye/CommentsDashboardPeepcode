require_relative '../../../../lib/wordpress/comments/client'
require_relative '../../../support/match_date'

describe Wordpress::Comments::Client do

  let(:client) { Wordpress::Comments::Client.new 'http://stuffdutchpeoplelike.com/comments/feed' }
  let(:xml)      { File.read(File.join('spec', 'fixtures', 'feed.xml')) }

  describe "#initialize" do
    it "stores a URL" do
      expect(client.url).to eq 'http://stuffdutchpeoplelike.com/comments/feed'
    end
  end

  describe "#parse" do
    let(:comments) { client.parse xml }
    let(:comment)  { comments.first }

    it "extracts the link" do
      link = 'http://stuffdutchpeoplelike.com/2014/05/05/no-59-canadians/#comment-20014'
      expect(comment[:link]).to eq link
    end

    it "extracts the title" do
      title = "Comment on No.59: Canadians by Gerard Rosenboom"
      expect(comment[:title]).to eq title
    end

    it "extracts the name of the commentor" do
      expect(comment[:commenter]).to eq 'Gerard Rosenboom'
    end

    it "extracts the publication date" do
      expect(comment[:date].year).to eq 2014
    end

    it "extracts the publication date (redux)" do
      expect(comment[:date]).to match_date '2014-05-06'
    end
  end

  describe "#fetch" do
    let(:comments) { client.fetch }

    context "success" do
      before(:each) do
        allow(client).to receive(:get).and_return(xml)
      end

      it "build comment objects" do
        expect(comments.length).to eq 10
      end
    end

    context "bad URL" do
      let(:client) { Wordpress::Comments::Client.new 'not a URL' }

      it "raises error" do
        expect {
          client.fetch
        }.to raise_error(Errno::ENOENT)
      end
    end

    context "bad XML" do
      before(:each) do
        allow(client).to receive(:get).and_return("BAD XML!")
      end

      it "raise error from Nokogiri" do
        expect {
          client.fetch
        }.to raise_error(Nokogiri::XML::SyntaxError)
      end
    end
  end
end
