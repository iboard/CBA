require 'test_helper'

class PagesHelperTest < ActionView::TestCase

  def self.create_one_page!(title,body="TESTBODY")
    Page.delete_all
    Page.create!(:title => title, :body => body )
  end

  def self.default_component_template_id
    template = PageTemplate.find_or_create_by(:name => 'Component: default')
    template.html_template = "<h2>TITLE</h2><div class='component_body'>BODY</div>"
    template.css_class = "component_default"
    template.save!
    template.id
  end
end
