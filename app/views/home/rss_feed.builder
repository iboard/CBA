atom_feed(:url => feed_path) do |feed|
   feed.title(APPLICATION_CONFIG['rss_title'])
   feed.updated(Time.now)
   for item in @feed_items
     feed.entry(item.object, :url => item.url) do |entry|
       entry.title(item.title)
       content = ""
       begin
         interpret item.object do |presenter|
           content += presenter.title
           content += presenter.cover_picture if presenter.respond_to?(:cover_picture)
           content += presenter.body
         end
       rescue => e
         content = "ERROR: " + e.inspect
       end
       entry.content( content, :type => :html )
       entry.updated item.updated_at
       entry.author(item.name||'-')
     end
   end
end