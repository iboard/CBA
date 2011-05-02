# -*- encoding : utf-8 -*-
require 'test_helper'

class PageTemplateTest < ActiveSupport::TestCase

  def setup
    Page.delete_all
    PageTemplate.delete_all
    @template = Factory.create(:page_template, :name => 'default')
    @page = Factory.create(:page_with_default_template, :title => 'With a template', :body => 'Lorem ipsum of main body')
    @page.page_template = @template
    @page.save
  end

  def cleanup
    Page.delete_all
    PageTemplate.delete_all
  end

  test "Page should embed a page_template" do
    @page.page_components.build(:title => 'Comp 1', :body => 'Component One', :position => 1)
    @page.page_components.build(:title => 'Comp 2', :body => 'Component Two', :position => 2)
    @page.save!
    @page.reload
    assert @page.page_template.html_template =~ /TITLE/, 'Default template should render TITLE'
    assert @page.page_template.html_template =~ /BODY/, 'Default template should render BODY'
    assert @page.page_template.html_template =~ /BUTTONS/, 'Default template should render BUTTONS'
    assert @page.page_template.html_template =~ /COMMENTS/, 'Default template should render COMMENTS'
  end

  test "Page should render with default template" do
    @page.page_components.create(:title => 'Comp 1', :body => 'Component One', :position => 1)
    @page.page_components.create(:title => 'Comp 2', :body => 'Component Two', :position => 2)
    @page.save!
    @page.reload
    assert @page.render_body =~ /With a template/, "Body should contain title #{@page.render_body}"
    assert @page.render_body =~ /Component One/, 'Body should contian Component One'
    assert @page.render_body =~ /Component Two/, 'Body should contian Component Two'
  end

  test "Page template should not be deleted if in use" do
    template = PageTemplate.first
    assert !template.delete, "Template is in use and should not be deleted"
  end

  test "Page template should be deleted if not in use" do
    template = PageTemplate.first
    Page.all.each do |page|
      page.update_attributes!( :page_template_id => nil )
    end
    assert template.delete, "Template is not in use and should be deleted"
  end


end
