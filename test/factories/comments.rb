FactoryGirl.define do
  factory :comment do |c|
    c.name      'Your Name'
    c.email     'your@email.cc'
    c.comment   'Lorem ipsum commentum'
  end
end
