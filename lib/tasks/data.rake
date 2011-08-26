namespace :data do
  desc "Generate standard root_menu"
  task :generate_standard_root_menu => :environment do
    print "Generating site_menus ... "
    SiteMenu.delete_all
    home   = SiteMenu.create            position: 1, name: 'Home',          target: "/" 
    admin  = SiteMenu.create            position: 2, name: 'Admin',         target: "/registrations"
    userlist=admin.children.create      position: 3, name: 'Userlist',      target: "/registrations"
    my_account= admin.children.create   position: 4, name: 'Profile Setup', target: "/users/edit"
    account= my_account.children.create position: 5, name: 'Account',       target: "/users/edit"
    pages  = SiteMenu.create            position: 6, name: 'Pages',         target: "/pages"
    Page.all.each do |page|
      pages.children.create name: page.title, target: "/pages/#{page.id.to_s}"
    end
    [ home, admin, pages].each do |menu|
      menu.save
    end
  end
  
  desc "Generate fulltext indeces"
  task :generate_fulltext_indeces => :environment do
    [Page,Posting].each do |resource|
      resource.update_ngram_index
    end
  end
end
    
