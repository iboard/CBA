require 'test_helper'

class BlogTest < ActiveSupport::TestCase

  def setup
    Blog.delete_all
  end

  test "sould not save without a title" do
    b = Blog.new
    assert !b.valid?, "A blog without a title should not be valid"
    b.title = 'My Testtitle'
    assert b.valid?, "A blog with a title sould be valid"
  end
  
  test "Title should be unique" do
    b1 = Blog.new(:title => "My Blog")    
    assert b1.save, "Should save if title is unique"
    
    b2 = Blog.new(:title => "My Blog")
    assert !b2.save, "Should not save with the same title again."
  end
  
end
