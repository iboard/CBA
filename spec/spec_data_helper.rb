# == SpecDataHelper
#
# Configured in 'spec_helper.rb' - config.include SpecDataHelper
# Functions we use in all specs to create test-data
#
module SpecDataHelper

  def at_exit
    puts "*** EXIT TESTS ****"
  end

  # Drop all documents of collections we'll test
  def cleanup_database
    begin
      Posting.unscoped.delete_all
      Blog.unscoped.delete_all
      User.unscoped.delete_all
      PageTemplate.delete_all
      Page.delete_all
    rescue => e
      puts "*** ERROR CLEANING UP DATABASE -- #{e.inspect}"
    end
  end

  # Create the default user set.
  # Admin is created first because the first user will have admin-role instantly.
  # Then create users with other roles.
  # To use the default userset
  #     log_in_as "_role_@iboard.cc", "thisisnotsecret"
  # Where '_role_' can be one of:
  # * admin@iboard.cc
  # * user@iboard.cc
  # * author@iboard.cc
  # * moderator@iboard.cc
  # * maintainer@iboard.cc
  # * staff@iboard.cc
  def create_default_userset
    User.unscoped.delete_all
    [
      #ROLES = [:guest, :confirmed_user, :author, :moderator, :maintainer, :admin]
      #see user.rb model
      #
      #  ATTENTION cba makes the first user an admin!
      #  -> The first user of the following hash must be the admin!
      {
        :email => 'admin@iboard.cc',
        :name  => 'admin',
        :roles_mask => 5,
        :password => 'thisisnotsecret', :password_confirmation => 'thisisnotsecret',
        :confirmed_at => "2010-01-01 00:00:00"
      },
      # Define NON-ADMINS BELOW
      {
        :email => 'user@iboard.cc',
        :name  => 'testmax',
        :roles_mask => 1,
        :password => 'thisisnotsecret', :password_confirmation => 'thisisnotsecret',
        :confirmed_at => "2010-01-01 00:00:00"
      },
      {
        :email => 'author@iboard.cc',
        :name  => 'Author',
        :roles_mask => 2,
        :password => 'thisisnotsecret', :password_confirmation => 'thisisnotsecret',
        :confirmed_at => "2010-01-01 00:00:00"
      },
      {
        :email => 'moderator@iboard.cc',
        :name  => 'Moderator',
        :roles_mask => 3,
        :password => 'thisisnotsecret', :password_confirmation => 'thisisnotsecret',
        :confirmed_at => "2010-01-01 00:00:00"
      },
      {
        :email => 'maintainer@iboard.cc',
        :name  => 'maintainer',
        :roles_mask => 4,
        :password => 'thisisnotsecret', :password_confirmation => 'thisisnotsecret',
        :confirmed_at => "2010-01-01 00:00:00"
      },
      {
        :email => 'staff@iboard.cc',
        :name  => 'staff',
        :roles_mask => 4,
        :password => 'thisisnotsecret', :password_confirmation => 'thisisnotsecret',
        :confirmed_at => "2010-01-01 00:00:00"
      }
    ].each do |hash|
      User.create(hash)
    end
  end

  # Create a valid and visible posting for user with _email_
  # If blog 'News' doesn't exist, it will be created.
  # @param [String] email - use one of 'default_user_set'
  # @return [Posting]
  def create_posting_for(email,attributes={})
    user = User.where( :email => email).first
    attributes.merge! :user_id => user.id
    blog = Blog.first || Blog.create!(:title => 'News')
    posting = blog.postings.create(attributes)
    unless posting.valid?
      puts "\n#  New Posting has errors #{posting.errors.inspect}\n"
    end
    posting.save!
    blog.save!
    posting
  end

  # Do something (the block) with the user-object.
  # @param [String] email - use one of 'default_user_set'
  def with_user user_email, &block
    user = User.where(:email => user_email).first
    yield(user)
  end

  # Login
  # @param [String] user_email, use one of default_user_set
  # @param [String] password, is always hardcoded as 'thisisnotsecret'
  def log_in_as(user_email,password)
    with_user(user_email) do |user|
        visit "/users/sign_in"
        fill_in("Email", :with => user.email)
        fill_in("Password", :with => password)
        click_button("Sign in")
    end
  end

  # Create a default PageTemplate
  def create_default_page_template
    PageTemplate.create(:name => 'default')
  end

  # Create a page with one component
  # @param [Hash] options, The page attributes plus :page_component => {attributes}
  # @return [Page], the created page
  def create_page_with_component( options )
    component = options[:page_component]
    template = create_default_page_template
    component.merge! :page_template_id => template.id
    options.delete(:page_component)
    options.merge! :page_template_id => template.id
    page = Page.new(options)
    unless page.valid?
      puts "***** PAGE INVALID IN #{__FILE__}:#{__LINE__} - #{page.errors.inspect} *****"
    end
    page.page_components.create(component)
    page.save!
    page
  end
end
