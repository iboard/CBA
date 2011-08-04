FactoryGirl.define do
  factory :page_template do |t|
   t.name           "default"
   t.css_class      "default"
   t.html_template  "<h1>TITLE</h1>COVERPICTURE<hr>BODY<hr>COMPONENTS<hr>BUTTONS<hr>COMMENTS"
 end
end
