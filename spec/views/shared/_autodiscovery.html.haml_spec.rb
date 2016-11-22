require 'spec_helper'

describe 'shared/_autodiscovery.html.haml' do
  before do
    view.stub(:autodiscovery_url).and_return "http://www.usa.gov/"
    view.stub(:discovered_resources)
  end

  it 'reports discovery complete' do
    render
    expect(rendered).to start_with("Discovery complete for http://www.usa.gov/")
  end

  context 'no new social media, RSS feeds, or favicon URL are discovered' do
    it 'reports no new resources found' do
      render
      expect(rendered).to include("No new resources were found.")
    end
  end

  context 'social media, RSS feeds, and favicon URL are discovered' do
    before do
      view.stub(:discovered_resources).and_return('Favicon URL' => ["http://www.usa.gov/sites/all/themes/usa/images/USA_Fav_Icon16.ico"],
                                                  'RSS Feeds' => ["http://www.usa.gov/rss_feed/1.xml",
                                                                  "http://www.usa.gov/rss_feed/2.xml",
                                                                  "http://www.usa.gov/rss_feed/3.xml"],
                                                  'Social Media' => ["https://www.flickr.com/photos/depsecdef",
                                                                     "https://www.youtube.com/channel/UCOO7o2HpFshqZe_KJaMVYlg",
                                                                     "https://instagram.com/ok_dept_of_libraries",
                                                                     "https://twitter.com/lorensiebert"])
    end

    it 'renders all of them' do
      render
      expect(rendered).to include("We found the following resources and have added them to your site:")
      expect(rendered).to have_css("dt", text: "Favicon URL")
      expect(rendered).to have_css("dd", text: "http://www.usa.gov/sites/all/themes/usa/images/USA_Fav_Icon16.ico")
      expect(rendered).to have_css("dt", text: "RSS Feeds")
      expect(rendered).to have_css("dd", text: ["http://www.usa.gov/rss_feed/1.xml",
                                                "http://www.usa.gov/rss_feed/2.xml",
                                                "http://www.usa.gov/rss_feed/3.xml"].join(', '))
      expect(rendered).to have_css("dt", text: "Social Media")
      expect(rendered).to have_css("dd", text: ["https://www.flickr.com/photos/depsecdef",
                                                "https://www.youtube.com/channel/UCOO7o2HpFshqZe_KJaMVYlg",
                                                "https://instagram.com/ok_dept_of_libraries",
                                                "https://twitter.com/lorensiebert"].join(', '))
    end
  end
end
