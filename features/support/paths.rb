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
    when /the profile page of user "([^"]*)/
      username = $1
      user = User.where(name: username).first
      "/profile/#{user.id}"
    when /(the )?edit page for "([^"]*)"/
      title = $1 == 'the ' ? $2 : $1
      page = Page.where(:title => title).first
      "/pages/#{page.id.to_s}/edit"
    when /(the )?edit page template for "([^"]*)"/
      title = $1 == 'the ' ? $2 : $1
      page = Page.unscoped.where(:title => title).first
      "/pages/#{page.id.to_s}/edit"
    when /(the )?page path of "([^"]*)"/
      title = $1 == 'the ' ? $2 : $1
      page = Page.unscoped.where(:title => title).first
      if page
        "/pages/#{page.id.to_s}"
      else
        "/pages"
      end
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
    when /feed/
      "/feed"
    when /edit site_menu page for menu "([^"]*)"/
      menu_name = $1
      site_menu = SiteMenu.where(:name => menu_name).first
      "/site_menus/#{site_menu.id.to_s}/edit"
    when /the templates page/
      "/pages/templates"
    when /the new_article page/
      "/pages/new_article"
    when /the edit first component path for "([^"]*)"/
      page_title = $1
      page = Page.where(:title => page_title).first
      component = page.page_components.first
      "/pages/#{page.id.to_s}/page_components/#{component.id.to_s}/edit"
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
