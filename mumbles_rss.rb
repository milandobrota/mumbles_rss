require 'rubygems'
require 'sanitize'
require 'feedzirra'

rss_feed = ''

feed = Feedzirra::Feed.fetch_and_parse(rss_feed)

loop do
  sleep(30)
  unless feed == 0 || feed.new_entries.size == 0
    feed.new_entries.each do |entry|
      system "mumbles-send \"#{entry.title}\" \"#{Sanitize.clean(entry.summary)}\""
    end
    feed.new_entries = []
  end
  temp_feed = Feedzirra::Feed.update(feed)
  feed = temp_feed unless temp_feed == 0
end
