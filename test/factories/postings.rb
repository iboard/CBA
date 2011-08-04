FactoryGirl.define do
  factory :posting do |p|
   p.title      'Posting 1'
   p.body       "Lorem ipsum"
   p.user_id    "4d2c96042d194751eb000001"
   p.blog_id    "4d2c96042d194751eb000002"
   p.is_draft   false
 end
end


