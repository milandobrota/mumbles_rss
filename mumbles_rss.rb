require 'rubygems'
require 'sanitize'
require 'feedzirra'

rss_feed_links = ['']

feeds = []
rss_feed_links.each do |feed_link|
  feeds << Feedzirra::Feed.fetch_and_parse(feed_link)
end


loop do
  sleep(30)
  feeds.each do |feed|
    unless feed == 0 || feed.new_entries.size == 0
      feed.new_entries.each do |entry|
        system "mumbles-send \"#{entry.title}\" \"#{Sanitize.clean(entry.summary)}\""
      end
      feed.new_entries = []
    end
    temp_feed = Feedzirra::Feed.update(feed)
    feed = temp_feed unless temp_feed == 0
  end
end
