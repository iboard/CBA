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
    pending
    # Since we use links to page-component edit, render_body couldn't work
    # without a view-context. This functionality is tested with cucumber, tho.
  end

  test "Page component should be translatable" do
    page = Page.first || Factory.create(:page, :title => 'Testpage', :body => 'Main Body of page')
    c = page.page_components.create( title: 'Testcomponent', body: 'Testbody')
    c.translate!
    c.t :de, :title, 'Testkomponente'
    c.t :de, :body, 'Testkoerper'
    page.save!
    page.reload
    assert page.page_components.first.t(:de, :title).eql?( "Testkomponente"), "Title of component isn't translated"
    assert page.page_components.first.t(:de, :body).eql?( "Testkoerper"), "Body of component isn't translated"
  end
  
  test "Page should not allow to remove components when allow_removing_component is false" do
    page = Page.first || Factory.create(:page, :title => 'Testpage', :body => 'Main Body of page')
    c = page.page_components.create( title: 'Testcomponent', body: 'Testbody')
    c.save!
    page.allow_removing_component = false
    page.save!
    assert !page.page_components.first.delete, "Page should not allow removing a component."
    page.allow_removing_component = true
    page.save!
    assert page.page_components.first.delete, "Page should allow removing a component."
    assert page.page_components.count == 0, "Page should have no components after removing the only one."
  end

end
