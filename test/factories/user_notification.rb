FactoryGirl.define do
  factory :user_notification do |n|
    n.message "This is a notification for a user"
    n.hidden  false
  end
end
