FactoryGirl.define do
  factory :blog do |p|
     p.title      'Blog 1'
     p.allow_comments true
     p.allow_public_comments true
     p.is_draft   false
  end
end