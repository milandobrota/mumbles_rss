require 'rubygems'
require 'sanitize'
require 'feedzirra'

feed = Feedzirra::Feed.fetch_and_parse('http://www.facebook.com/feeds/notifications.php?id=661315101&viewer=661315101&key=55bad83173&format=rss20')

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
