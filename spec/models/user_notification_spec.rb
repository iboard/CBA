require 'spec_helper'

describe "UserNotifications" do

  before(:all) do
    cleanup_database
    create_default_userset
  end
  
  before(:each) do
    @sender = User.where( email: 'admin@iboard.cc' ).first
  end
   
  it "schould deliver to addressed recipients" do
    notification = @sender.user_notifications.create( 
      { recipients: 'user@iboard.cc,maintainer@iboard.cc',
        message: 'Lorem ipsum ...' } 
    )
    ['user@iboard.cc', 'maintainer@iboard.cc','staff@iboard.cc']
    .each_with_index do |email,idx|
      receiver = User.where(email: email).first
      unless idx == 2
        assert_match receiver.user_notifications.last.message, /Lorem ipsum/
      else
        assert !receiver.user_notifications.any?, 
          "staff@iboard.cc should not have any notification"
      end
    end
    
  end

  it "schould deliver to all recipients" do
    notification = @sender.user_notifications.create( { message: 'Lorem ipsum ...' } )
    User.all do |receiver|
      assert_match receiver.user_notifications.last.message, /Lorem ipsum/
    end
  end
  
  it "should append recipients to the copy of the sender" do
    @sender.user_notifications.create( { message: 'Lorem ipsum ...', recipients: "" } )
    assert @sender.user_notifications.last.message =~ /All .* users/, 
      "All users should be displayed but is: #{@sender.user_notifications.last.message}"
    
    @sender.user_notifications.create( 
      { message: 'Lorem ipsum ...', recipients: "user@iboard.cc,staff@iboard.cc"  } 
    )
    
    assert_match @sender.user_notifications.last.message, /user@iboard.cc/
    assert_match @sender.user_notifications.last.message, /staff@iboard.cc/
    
  end
end
