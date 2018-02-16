require 'spec_helper'

describe SearchesController do
  fixtures :affiliates, :rss_feeds, :news_items
  let(:affiliate) { affiliates(:basic_affiliate) }

  context "#news" do
    context "when the request is from a mobile device" do
      before do
        iphone_user_agent = "Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1A543a Safari/419.3"
        get "/search/news", {:query => 'element', :affiliate => affiliate.name, :channel => rss_feeds(:white_house_blog).id}, { "HTTP_USER_AGENT" => iphone_user_agent }
      end

      it "should set format to mobile" do
        expect(request.format.to_sym).to eq(:mobile)
      end

      it "should sucessfully response" do
        expect(response.status).to eq(200)
      end
    end
  end

  context "#docs" do
    context "when the request is from a mobile device" do
      before do
        iphone_user_agent = "Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1A543a Safari/419.3"
        get "/search/docs", {:query => "pdf", :affiliate => affiliate.name}, { "HTTP_USER_AGENT" => iphone_user_agent }
      end

      it "should set format to mobile" do
        expect(request.format.to_sym).to eq(:mobile)
      end

      it "should respond with success" do
        expect(response.status).to eq(200)
      end
    end
  end
end