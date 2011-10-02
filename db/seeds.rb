# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)


#
# SET UP DEFAULT PAGE_TEMPLATE
#
default_template = PageTemplate.find_or_create_by(name: 'default')
default_template.css_class = 'template_default'
default_template.html_template = "<h1>TITLE</h1>"  +
  "<div style='clear: right; float: right; "   +
  "margin-left: 10px; margin-bottom: 10px;'>COVERPICTURE</div>" +
  "<address class='inline_buttons'>BUTTONS</address>"           +
  "<div class='page_body'>BODY</div>"                           +
  "<div class='page_attachments'>ATTACHMENTS</div>"             +
  "<div class='page_components'>COMPONENTS</div>"               +
  "<div class='page_comments'>COMMENTS</div>"
default_template.save!

default_template = PageTemplate.find_or_create_by(name: 'Page: Hidden attachments')
default_template.css_class = 'template_default'
default_template.html_template = "<h1>TITLE</h1>"  +
  "<div style='float: right; "   +
  "margin-left: 10px; margin-bottom: 10px;'>COVERPICTURE</div>" +
  "<address class='inline_buttons'>BUTTONS</address>"           +
  "<div class='page_body'>BODY</div>"                           +
  "<div class='page_components'>COMPONENTS</div>"               +
  "<div class='page_comments'>COMMENTS</div>"
default_template.save!


default_template = PageTemplate.find_or_create_by(name: 'Page: without coverpicture')
default_template.css_class = 'template_default'
default_template.html_template = "<h1>TITLE</h1>"     +
  "<address class='inline_buttons'>BUTTONS</address>" +
  "<div class='page_body'>BODY</div>"                 +
  "<div class='page_body'>ATTACHMENTS</div>"          +
  "<div class='page_components'>COMPONENTS</div>"     +
  "<div class='page_comments'>COMMENTS</div>"
default_template.save!

default_template = PageTemplate.find_or_create_by(name: 'Page: without title')
default_template.css_class = 'template_default'
default_template.html_template = "<div style='float: right; "   +
  "margin-left: 10px; margin-bottom: 10px;'>COVERPICTURE</div>" +
  "<address class='inline_buttons'>BUTTONS</address>" +
  "<div class='page_body'>BODY</div>"                 +
  "<div class='page_components'>COMPONENTS</div>"     +
  "<div class='page_body'>ATTACHMENTS</div>"          +
  "<div class='page_comments'>COMMENTS</div>"
default_template.save!

default_template = PageTemplate.find_or_create_by(name: 'Page: Body and components only')
default_template.css_class = 'template_default'
default_template.html_template = "<address class='inline_buttons'>BUTTONS</address>" +
  "<div class='page_body'>BODY</div>" +
  "<div class='page_components'>COMPONENTS</div>"     +
  "<div class='page_comments'>COMMENTS</div>"
default_template.save!

default_template = PageTemplate.find_or_create_by(name: 'Page: Body and Attachments')
default_template.css_class = 'template_default'
default_template.html_template = "<address class='inline_buttons'>BUTTONS</address>" +
  "<div class='page_body'>BODY</div>" +
  "<div class='page_components'>COMPONENTS</div>"     +
  "<div class='page_body'>ATTACHMENTS</div>"          +
  "<div class='page_comments'>COMMENTS</div>"
default_template.save!

default_template = PageTemplate.find_or_create_by(name: 'Page: Components only')
default_template.css_class = 'template_default'
default_template.html_template = "<address class='inline_buttons'>BUTTONS</address>" +
  "<div class='page_body'>BODY</div>" +
  "<div class='page_components'>COMPONENTS</div>"     +
  "<div class='page_comments'>COMMENTS</div>"
default_template.save!

default_template = PageTemplate.find_or_create_by(name: 'Page: Attachment one as picture')
default_template.css_class = 'template_default'
default_template.html_template = "<h1>TITLE</h1>"     +
  "<div style='float: left; margin-right: 10px; margin-bottom: 10px;'>ATTACHMENT[0]</div>" +
  "<address class='inline_buttons'>BUTTONS</address>" +
  "<div class='page_body'>BODY</div>"                 +
  "<div class='page_components'>COMPONENTS</div>"     +
  "<div class='page_comments'>COMMENTS</div>"
default_template.save!



#
#  COMPONENTS
#
default_component = PageTemplate.find_or_create_by(name: 'Component: default')
default_component.css_class = 'component_default'
default_component.html_template = "<h1>TITLE</h1>"   +
  "<div class='component_body'>BODY</div>"
default_component.save!

default_component = PageTemplate.find_or_create_by(name: 'Component: without title')
default_component.css_class = 'component_default'
default_component.html_template = "<div class='component_body'>BODY</div>"
default_component.save!

for i in (0..4).to_a
  default_component = PageTemplate.find_or_create_by(name: "Component: with attachment #{i+1}")
  default_component.css_class = 'component_default'
  default_component.html_template = "<div class='component_body'>"                         +
       "<div class='component_picture' "                                                   +
       "style='float: left; margin-right: 10px; margin-bottom: 10px;'>ATTACHMENT[#{i.to_s}]</div>" +
       "BODY"                                                                              +
     "</div>"
  default_component.save!
end


for width in [100,200,300,400,500]
  default_component = PageTemplate.find_or_create_by(name: "Component: float-left-box (#{width}px)")
  default_component.css_class = "component_float_left_#{width.to_s}"
  default_component.html_template = "BODY"
  default_component.save!
  
  default_component = PageTemplate.find_or_create_by(name: "Component: float-right-box (#{width}px)")
  default_component.css_class = "component_float_right_#{width.to_s}"
  default_component.html_template = "BODY"
  default_component.save!
end

default_component = PageTemplate.find_or_create_by(name: 'Component: clear-left')
default_component.css_class = 'clear_left'
default_component.html_template = "<div style='clear: left'></div>"
default_component.save!

default_component = PageTemplate.find_or_create_by(name: 'Component: clear-right')
default_component.css_class = 'clear_right'
default_component.html_template = "<div style='clear: right'></div>"
default_component.save!

default_component = PageTemplate.find_or_create_by(name: 'Component: clear-both')
default_component.css_class = 'clear_both'
default_component.html_template = "<div style='clear: both'></div>"
default_component.save!


puts "PageTemplate and PageComponentTemplates created. Please make sure to define the following css-classes in your stylesheet"
puts "\n\n/* PAGE TEMPALTES */\n\n"
PageTemplate.only(:css_class).map {|template| template.css_class}.uniq.each do |css_class| 
  puts ".#{css_class} {\n}\n\n"
end
