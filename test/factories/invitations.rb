FactoryGirl.define do
  factory :invitation do |p|
   p.sponsor      User.first
   p.name         "Frank Zappa"
   p.email        "some@where.at"
   p.role         'confirmed_user'
   p.token        'abcdefgh'
 end
end
