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
    when /edit roles page for "([^"]*)"/
      begin
        user = User.where(:name => $1).first
        "/users/#{user.id}/edit_roles"
      rescue Object => e
        raise "Can't find user #{user.name} / #{e.inspect}"
      end
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
