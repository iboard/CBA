atom_feed(:url => feed_path) do |feed|
   feed.title(APPLICATION_CONFIG['rss_title'])
   feed.updated(Time.now)
   for item in @feed_items
     _content = ""
     feed.entry(item.object, :url => item.url) do |entry|
       entry.title(item.title)
       begin
         interpret item.object do |presenter|
           _content += presenter.title(false) if presenter.respond_to?(:title)
           if presenter.respond_to?(:cover_picture) && item.object.cover_picture_exists?
             _content += presenter.cover_picture('', :medium,false) 
           end
           if presenter.respond_to?(:body)
             _content += presenter.body(false) 
           else
             _content += "NO BODY FUNCTION!"
           end
         end
       rescue => e
         _content += ("\n<br/>ERROR: " + e.inspect + "<br/>").html_safe
       end
       entry.content( _content, :type => :html )
       entry.updated item.updated_at
       entry.author(item.name||'-')
     end
   end
end