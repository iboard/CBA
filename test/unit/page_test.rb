require 'test_helper'

class PageTest < ActiveSupport::TestCase

  def setup
    Page.delete_all
  end

  test "sould not save without a title and a body" do
    p = Page.new
    assert !p.valid?, "A page without a title and body should not be valid"
    p.title = 'Testtitle'
    assert !p.valid?, "A page with a title but no body should not be valid"
    p.body = 'lorem ipsum'
    assert p.valid?, "A page with a title and a body should be valid"
  end
  
  test "Title should be unique" do
    p1 = Page.new(:title => "My Title", :body => 'Lorem')
    p2 = Page.new(:title => "My Title", :body => 'Lorem')
    
    assert p1.save, "Should save if title is unique"
    assert !p2.save, "Should not save with the same title again."
  end
  
  test "A comment should have a body" do
    p1 = Page.new(:title => "My Title", :body => 'Lorem')
    p1.comments.build( :email => 'test@server.to', :comment => '')
    assert !p1.save
  end
end
