FactoryGirl.define do
  factory :page do |p|
    p.title                 'Page 1'
    p.body                  "Lorem ipsum"
    p.show_in_menu          true
    p.allow_comments        true
    p.allow_public_comments true
    p.allow_removing_component true
    p.is_draft              false
    p.interpreter           :markdown
  end
end

FactoryGirl.define do
  factory :page_with_default_template, :class => Page do |p|
    p.title                 'Page 1'
    p.body                  "Lorem ipsum"
    p.show_in_menu          true
    p.allow_comments        true
    p.allow_public_comments true
    p.allow_removing_component true
    p.is_draft              false
    p.interpreter           :markdown
    p.page_template         PageTemplate.find_or_create_by(:name => 'default', :html_template => "TITLE BODY COMPONENTS COMMENTS BUTTONS")
  end
end
