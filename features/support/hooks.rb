Before do
  ActiveRecord::Fixtures.reset_cache
  ActiveRecord::Fixtures.create_fixtures('spec/fixtures', %w(users federal_register_agencies agencies affiliates statuses twitter_profiles memberships rss_feeds rss_feed_urls))
end
