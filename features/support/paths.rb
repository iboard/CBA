module NavigationHelpers
   
  # We are using UTF-8 ✔

  def path_to(page_name)
    
    case page_name
    when /the home page/
      '/'
    when /users page/
      '/registrations'
    when /registrations page/
      '/registrations'
    when /sign_in/
      '/users/sign_in'
    when /sign_out/
      '/users/sign_out'
    when /the edit user page/
      '/users/edit'
    when /edit page for "([^"]*)"/
      title = $1
      page = Page.where(:title => title).first
      "/pages/#{page._id}/edit"
    when /page path of "([^"]*)"/
      title = $1
      page = Page.where(:title => title).first
      "/pages/#{page._id}"
    when /permalink_path of "([^"]*)"/
      title = $1
      page = Page.where(:title => title).first
      "/p/#{page.link_to_title}"
    when /edit role page for "([^"]*)"/
      begin
        user = User.where(:name => $1).first
        "/users/#{user.id}/edit_role"
      rescue Object => e
        raise "Can't find user #{user.name} / #{e.inspect}"
      end
    when /blogs page/
      '/blogs'
    when /blog path of "([^"]*)"/
      title = $1
      blog = Blog.where(:title => title).first
      "/blogs/#{blog._id}"
    when /the read posting "([^"]*)" page of blog "([^"]*)"/
      posting_title = $1
      blog_title = $2
      blog = Blog.where(:title => blog_title).first
      posting = blog.postings.where(:title => posting_title).first
      "/blogs/#{blog._id}/postings/#{posting._id}"
    when /the posting page of "([^"]*)"/
      posting=Posting.where(:title=> $1).first
      "/postings/#{posting.id}"
    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "With the following path_components \"#{path_components.inspect}\"\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
