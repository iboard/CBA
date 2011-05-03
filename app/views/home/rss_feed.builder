atom_feed(:url => feed_path) do |feed|
   feed.title(APPLICATION_CONFIG['rss_title'])

   feed.updated(Time.now) #@feed_items.first ? @feed_items.first.updated_at : Time.now.utc )
   for item in @feed_items
     feed.entry(item.object, :url => item.url) do |entry|
       entry.title(item.title)
       if item.object.respond_to?(:render)
         content = item.object.render(self)
       else
         content = sanitize(simple_format(item.body))
       end
       if defined? item.object.cover_picture
         content += image_tag item.object.cover_picture.url(:medium)
       end
       entry.content( content, :type => :html)
       entry.updated item.updated_at
       entry.author(item.name||'-')
     end
   end
end