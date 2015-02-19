require 'spec_helper'

describe SpellingSuggestionsHelper do
  let(:affiliate) { mock_model(Affiliate, name: 'usasearch') }
  let(:search) do
    mock('Search',
         affiliate: affiliate,
         query: '<initialquery>',
         queried_at_seconds: Time.current.to_i,
         spelling_suggestion: '<suggestion>')
  end

  describe '#spelling_suggestion(search, search_options)' do
    it 'should return HTML escaped output containing the initial query with site_limits and the suggestion' do
      html = helper.spelling_suggestion(search, site_limits: 'blogs.cdc.gov/niosh-science-blog www.cdc.gov/niosh')
      html.should have_link('<suggestion>', '/search?affiliate=usasearch&amp;query=%3Csuggestion%3E&amp;sitelimit=blogs.cdc.gov%2Fniosh-science-blog+www.cdc.gov%2Fniosh')
      html.should have_content('Showing results for <suggestion>')
      html.should have_content('Search instead for <initialquery>')
    end
  end

  describe '#legacy_spelling_suggestion(search, affiliate, vertical)' do
    it 'should return HTML escaped output containing the initial query and the suggestion' do
      html = helper.legacy_spelling_suggestion(search, affiliate, :web)
      html.should contain("We're including results for <suggestion>. Do you want results only for <initialquery>?")
      html.should =~ /&lt;initialquery&gt;/
      html.should =~ /&lt;suggestion&gt;/
    end
  end
end
