require 'test_helper'

class BlogTest < ActiveSupport::TestCase

  def setup
    Blog.delete_all
    Pages.delete_all
  end

  def cleanup
    Blog.delete_all
    Pages.delete_all
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

  test "A blog should have assigned pages" do
    b1 = Blog.new(:title => "Blog with pages")
    p1 = Factory.create(:page)
    b1.pages << p1
    assert b1.save, 'Blog should save with pages'
    b1.reload
    assert b1.pages.first == p1, 'Blog should be assigned to page'
  end


end
