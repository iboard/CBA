module SpecDataHelper


  def self.cleanup_database
    puts "# Cleaning Posting database"
    Posting.unscoped.delete_all
    puts "# Cleaning Blogs database"
    Blog.unscoped.delete_all
    puts "# Drop user database"
    User.unscoped.delete_all
  end

  def self.create_default_userset
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


  def self.create_posting_for(email,attributes={})
    user = User.where( :email => email).first
    attributes.merge! :user_id => user.id
    blog = Blog.first || Blog.create!(:title => 'News')
    posting = blog.postings.create(attributes)
    unless posting.valid?
      puts "#  New Posting has errors #{posting.errors.inspect}"
    end
    posting.save!
    blog.save!
    posting
  end

  def self.with_user user_email, &block
    user = User.where(:email => user_email).first
    yield(user)
  end

end
