require 'simplecov'
SimpleCov.start do
  add_filter "/test/"
end

require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] = "test"
  require File.expand_path('../../config/environment', __FILE__)
  require 'rails/test_help'
  include Devise::TestHelpers
end

Spork.each_run do
  # This code will be run each time you run your specs.
  Dir[File.expand_path(File.join(File.dirname(__FILE__),'..','..',
    'spec','factories','*.rb'))].each { |f| require f }
end



class ActiveSupport::TestCase

  def create_valid_user_with_id(id=nil)
    begin
      unless id.nil?
        user = User.new(
                        :id => id, :email => 'tester@test.te', :name => 'nockenfell',
                        :password => 'secret', :password_confirmation => 'secret'
                       )
      else
        user = User.new(
                        :email => 'tester@test.te', :name => 'nockenfell',
                        :password => 'secret', :password_confirmation => 'secret'
                       )
      end
      user.save!
      user
    rescue
      nil
    end
  end

  def create_valid_user_with_roles_mask(role)
    user = User.new(
                      :email => "#{role.to_s}@test.te", :name => role.to_s,
                      :password => 'secret', :password_confirmation => 'secret'
                   )
    user.role=role
    user.save!
    user
  end

  def create_one_page(title='A Page', body='A Body')
     Page.delete_all
     Page.create title: title, body: body
  end

end
