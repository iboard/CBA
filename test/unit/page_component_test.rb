# -*- encoding : utf-8 -*-
require 'test_helper'

class PageComponentTest < ActiveSupport::TestCase

  def setup
    Page.delete_all
    PageTemplate.delete_all
  end

  def cleanup
    Page.delete_all
    PageTemplate.delete_all
  end

  test "Page should store page_components" do
    page = Factory.create(:page, :title => 'A Page with components',
                          :body => 'Main Body Loremsum Ipsum')
    page.page_components.build(:title => 'Component One', :position => 1)
    page.save!
    page.reload
    assert page.page_components.first.title == 'Component One', 'Component of page not found after reload'
  end


  test "Page should render all page_components" do
    page = Page.first || Factory.create(:page, :title => 'Testpage', :body => 'Main Body of page')
    page.page_components.delete_all
    page.page_components.build(:title => 'Component One', :position => 1)
    page.page_components.build(:title => 'Component Two', :position => 2)
    page.save!
    page.reload
    assert page.render_body =~ /Main Body of page/, 'Main Body should be in render'
    assert page.render_body =~ /Component One/, 'Component One should be in render'
    assert page.render_body =~ /Component Two/, 'Component Two should be in render'
  end


end
