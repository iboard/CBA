Factory.define :page do |p|
   p.title                 'Page 1'
   p.body                  "Lorem ipsum"
   p.show_in_menu          true
   p.allow_comments        true
   p.allow_public_comments true
end

Factory.define :page_with_default_template, :class => Page do |p|
  p.title                 'Page 1'
  p.body                  "Lorem ipsum"
  p.show_in_menu          true
  p.allow_comments        true
  p.allow_public_comments true
  p.page_template         PageTemplate.find_or_create_by(:name => 'default')
end


