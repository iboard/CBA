ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

include Devise::TestHelpers

class ActiveSupport::TestCase
  
  def create_valid_user_with_id(id)
    user = User.new(
                    :id => id, :email => 'tester@test.te', :name => 'nockenfell',
                    :password => 'secret', :password_confirmation => 'secret'
                   )
    user.save!
    user
  end
  
end
