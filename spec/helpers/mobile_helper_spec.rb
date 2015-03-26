require 'spec_helper'

describe MobileHelper do
  describe '#font_stylesheet_link_tag' do
    context 'font_family is blank' do
      it 'returns default css font family' do
        affiliate = mock_model(Affiliate, css_property_hash: {})
        helper.font_stylesheet_link_tag(affiliate).should include(MobileHelper::DEFAULT_FONT_STYLESHEET_LINK)
      end
    end
  end

  describe '#mobile_header' do
    context 'when unable to retrieve mobile logo URL' do
      it 'renders the site display name' do
        mobile_logo = mock('mobile logo')
        mobile_logo.should_receive(:url).and_raise
        affiliate = mock_model(Affiliate,
                               display_name: 'USASearch',
                               mobile_logo: mobile_logo,
                               mobile_logo_file_name: 'logo.png',
                               website: nil)

        helper.mobile_header(affiliate).should have_selector(:h1, content: 'USASearch')
      end
    end
  end

  describe '#search_results_by_text' do
    context 'when module_tag is GWEB' do
      it 'returns Powered by Google' do
        helper.search_results_by_text('GWEB').should have_content('Powered by Google')
      end
    end
  end

  describe '#serp_attribution' do
    context 'when module_tag is GWEB' do
      it 'returns Powered by Google' do
        helper.serp_attribution('GWEB').should have_content('Powered by Google')
      end
    end
  end

  describe "#related_sites_dropdown_label" do
    context 'when label is present' do
      specify { helper.related_sites_dropdown_label('foo').should == 'foo' }
    end

    context 'when label is nil' do
      specify { helper.related_sites_dropdown_label(nil).should == I18n.t(:'searches.related_sites') }
    end
  end

  describe "#html_class_hash" do
    context 'when locale is written right-to-left' do
      it 'should set the HTML direction to rtl' do
        helper.html_class_hash(:ar)[:dir].should == 'rtl'
      end
    end
  end
end
